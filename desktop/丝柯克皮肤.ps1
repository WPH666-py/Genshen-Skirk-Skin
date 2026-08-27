# ============================================================
# 丝柯克（Skirk）桌面皮肤 v1.0  ·  Windows PowerShell + WPF
# ------------------------------------------------------------
# 悬浮于任意应用之上（VSCode / PyCharm / Trae / WebStorm /
# claude-code / CodeX / kimi-code / Harness 等全部适用）。
# 左键点击：释放元素爆发「极恶技·灭」+ 中文语音「沉于渊海。」
# 拖动：移动位置；右键：菜单（收起 / 开机自启 / 一键卸载 / 退出）
# 建议通过同目录 启动-丝柯克皮肤.bat 启动。
# ============================================================
param()

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$script:imgFile   = Join-Path $PSScriptRoot '素材\丝柯克-web.jpg'
$script:voiceFile = Join-Path $PSScriptRoot '素材\语音-沉于渊海.wav'
$script:skillText = '元素爆发 · 极恶技·灭'
$script:voiceLine = '“沉于渊海。”'

$script:runKeyPath  = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run'
$script:runValueName = 'GenshenSkirkSkin'
$script:launchCmd = 'powershell.exe -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File "' + $PSCommandPath + '"'

# ---------- 工具 ----------
function New-Solid([byte]$a, [byte]$r, [byte]$g, [byte]$b) {
  $brush = New-Object System.Windows.Media.SolidColorBrush
  $brush.Color = [System.Windows.Media.Color]::FromArgb($a, $r, $g, $b)
  return $brush
}
function New-DoubleAnim([double]$from, [double]$to, [int]$ms, [bool]$autoReverse) {
  $anim = New-Object System.Windows.Media.Animation.DoubleAnimation
  $anim.From = $from; $anim.To = $to
  $anim.Duration = New-Object System.Windows.Duration([TimeSpan]::FromMilliseconds($ms))
  $anim.AutoReverse = $autoReverse
  return $anim
}
function New-Frames([int]$ms) {
  $frames = New-Object System.Windows.Media.Animation.DoubleAnimationUsingKeyFrames
  $frames.Duration = New-Object System.Windows.Duration([TimeSpan]::FromMilliseconds($ms))
  return $frames
}
function Add-KeyFrame($frames, [double]$value, [double]$percent) {
  $frames.KeyFrames.Add((New-Object System.Windows.Media.Animation.LinearDoubleKeyFrame($value, [System.Windows.Media.Animation.KeyTime]::FromPercent($percent))))
}
function Animate-Opacity($element, $frames) {
  $element.BeginAnimation([System.Windows.UIElement]::OpacityProperty, $frames)
}

# ---------- 声音 ----------
$script:player = New-Object System.Media.SoundPlayer($script:voiceFile)
try { $script:player.Load() } catch { Write-Host ('语音加载失败: ' + $_.Exception.Message) }

# ---------- 屏幕位置 ----------
$screen = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea
$startLeft = [Math]::Max(20, $screen.Right  - 380)
$startTop  = [Math]::Max(20, $screen.Bottom - 500)

# ============================================================
# 主窗口
# ============================================================
$script:win = New-Object System.Windows.Window
$script:win.Width = 360
$script:win.Height = 434
$script:win.WindowStyle = [System.Windows.WindowStyle]::None
$script:win.AllowsTransparency = $true
$script:win.Background = [System.Windows.Media.Brushes]::Transparent
$script:win.Topmost = $true
$script:win.ShowInTaskbar = $false
$script:win.ResizeMode = [System.Windows.ResizeMode]::NoResize
$script:win.Left = $startLeft
$script:win.Top = $startTop

$root = New-Object System.Windows.Controls.Grid
$script:win.Content = $root
$row0 = New-Object System.Windows.Controls.RowDefinition; $row0.Height = New-Object System.Windows.GridLength(46)
$row1 = New-Object System.Windows.Controls.RowDefinition; $row1.Height = New-Object System.Windows.GridLength(320)
$row2 = New-Object System.Windows.Controls.RowDefinition; $row2.Height = New-Object System.Windows.GridLength(58)
$root.RowDefinitions.Add($row0) | Out-Null
$root.RowDefinitions.Add($row1) | Out-Null
$root.RowDefinitions.Add($row2) | Out-Null

# 技能名字幕
$script:skillLabel = New-Object System.Windows.Controls.TextBlock
$script:skillLabel.Text = $script:skillText
$script:skillLabel.HorizontalAlignment = 'Center'
$script:skillLabel.VerticalAlignment = 'Bottom'
$script:skillLabel.FontFamily = 'Microsoft YaHei'
$script:skillLabel.FontSize = 19
$script:skillLabel.FontWeight = 'Bold'
$script:skillLabel.Foreground = New-Solid 255 207 233 255
$script:skillLabel.Effect = New-Object System.Windows.Media.Effects.DropShadowEffect
$script:skillLabel.Effect.BlurRadius = 12
$script:skillLabel.Effect.ShadowDepth = 0
$script:skillLabel.Effect.Color = [System.Windows.Media.Color]::FromArgb(255, 120, 190, 255)
$script:skillLabel.Opacity = 0
[System.Windows.Controls.Grid]::SetRow($script:skillLabel, 0)
$root.Children.Add($script:skillLabel) | Out-Null

# 台词字幕
$script:lineLabel = New-Object System.Windows.Controls.TextBlock
$script:lineLabel.Text = $script:voiceLine
$script:lineLabel.HorizontalAlignment = 'Center'
$script:lineLabel.VerticalAlignment = 'Top'
$script:lineLabel.FontFamily = 'Microsoft YaHei'
$script:lineLabel.FontSize = 24
$script:lineLabel.FontWeight = 'Bold'
$script:lineLabel.Foreground = New-Solid 255 238 247 255
$script:lineLabel.Effect = New-Object System.Windows.Media.Effects.DropShadowEffect
$script:lineLabel.Effect.BlurRadius = 14
$script:lineLabel.Effect.ShadowDepth = 0
$script:lineLabel.Effect.Color = [System.Windows.Media.Color]::FromArgb(255, 140, 205, 255)
$script:lineLabel.Opacity = 0
[System.Windows.Controls.Grid]::SetRow($script:lineLabel, 2)
$root.Children.Add($script:lineLabel) | Out-Null

# 卡片组（含抖动/浮动变换）
$script:cardGroup = New-Object System.Windows.Controls.Grid
$script:cardGroup.Width = 320
$script:cardGroup.Height = 320
$script:cardGroup.HorizontalAlignment = 'Center'
$script:cardGroup.VerticalAlignment = 'Center'
$script:bobY = New-Object System.Windows.Media.TranslateTransform
$script:shakeX = New-Object System.Windows.Media.TranslateTransform
$script:shakeY = New-Object System.Windows.Media.TranslateTransform
$group = New-Object System.Windows.Media.TransformGroup
$group.Children.Add($script:bobY) | Out-Null
$group.Children.Add($script:shakeX) | Out-Null
$group.Children.Add($script:shakeY) | Out-Null
$script:cardGroup.RenderTransform = $group
[System.Windows.Controls.Grid]::SetRow($script:cardGroup, 1)
$root.Children.Add($script:cardGroup) | Out-Null

# 立绘卡片
$bmp = New-Object System.Windows.Media.Imaging.BitmapImage((New-Object System.Uri($script:imgFile)))
$bmp.Freeze()
$imgBrush = New-Object System.Windows.Media.ImageBrush($bmp)
$imgBrush.Stretch = [System.Windows.Media.Stretch]::UniformToFill
$card = New-Object System.Windows.Controls.Border
$card.Width = 320
$card.Height = 320
$card.CornerRadius = New-Object System.Windows.CornerRadius(30)
$card.Background = $imgBrush
$card.BorderBrush = New-Solid 200 150 200 255
$card.BorderThickness = New-Object System.Windows.Thickness(1)
$card.Effect = New-Object System.Windows.Media.Effects.DropShadowEffect
$card.Effect.BlurRadius = 26
$card.Effect.ShadowDepth = 8
$card.Effect.Opacity = 0.55
$card.Effect.Color = [System.Windows.Media.Color]::FromArgb(255, 0, 0, 0)
$script:cardGroup.Children.Add($card) | Out-Null

# 爆发层画布
$burstCanvas = New-Object System.Windows.Controls.Canvas
$burstCanvas.Width = 320
$burstCanvas.Height = 320
$burstCanvas.IsHitTestVisible = $false
$script:cardGroup.Children.Add($burstCanvas) | Out-Null

# 闪光
$script:flashRect = New-Object System.Windows.Shapes.Rectangle
$script:flashRect.Width = 320
$script:flashRect.Height = 320
$script:flashRect.RadiusX = 30
$script:flashRect.RadiusY = 30
$flashBrush = New-Object System.Windows.Media.RadialGradientBrush
$flashBrush.Center = New-Object System.Windows.Point(0.5, 0.4)
$flashBrush.GradientOrigin = $flashBrush.Center
$flashBrush.GradientStops.Add((New-Object System.Windows.Media.GradientStop([System.Windows.Media.Color]::FromArgb(242, 190, 235, 255), 0))) | Out-Null
$flashBrush.GradientStops.Add((New-Object System.Windows.Media.GradientStop([System.Windows.Media.Color]::FromArgb(128, 90, 140, 255), 0.45))) | Out-Null
$flashBrush.GradientStops.Add((New-Object System.Windows.Media.GradientStop([System.Windows.Media.Color]::FromArgb(0, 30, 60, 140), 1))) | Out-Null
$script:flashRect.Fill = $flashBrush
$script:flashRect.Opacity = 0
$burstCanvas.Children.Add($script:flashRect) | Out-Null

# 冲击波圆环
$script:ring = New-Object System.Windows.Shapes.Ellipse
$script:ring.Width = 230
$script:ring.Height = 230
$script:ring.Stroke = New-Solid 230 160 220 255
$script:ring.StrokeThickness = 5
$script:ring.RenderTransformOrigin = New-Object System.Windows.Point(0.5, 0.5)
$script:ringScale = New-Object System.Windows.Media.ScaleTransform
$script:ring.RenderTransform = $script:ringScale
$script:ring.Opacity = 0
[System.Windows.Controls.Canvas]::SetLeft($script:ring, 45)
[System.Windows.Controls.Canvas]::SetTop($script:ring, 45)
$burstCanvas.Children.Add($script:ring) | Out-Null

# 三道斩光
$script:slashes = @()
for ($i = 0; $i -lt 3; $i++) {
  $slash = New-Object System.Windows.Shapes.Rectangle
  $slash.Opacity = 0
  $slashBrush2 = New-Object System.Windows.Media.LinearGradientBrush
  $slashBrush2.StartPoint = New-Object System.Windows.Point(0, 0.5)
  $slashBrush2.EndPoint = New-Object System.Windows.Point(1, 0.5)
  $slashBrush2.GradientStops.Add((New-Object System.Windows.Media.GradientStop([System.Windows.Media.Color]::FromArgb(0, 230, 248, 255), 0))) | Out-Null
  $slashBrush2.GradientStops.Add((New-Object System.Windows.Media.GradientStop([System.Windows.Media.Color]::FromArgb(242, 230, 248, 255), 0.3))) | Out-Null
  $slashBrush2.GradientStops.Add((New-Object System.Windows.Media.GradientStop([System.Windows.Media.Color]::FromArgb(230, 160, 220, 255), 0.6))) | Out-Null
  $slashBrush2.GradientStops.Add((New-Object System.Windows.Media.GradientStop([System.Windows.Media.Color]::FromArgb(0, 160, 220, 255), 1))) | Out-Null
  $slash.Fill = $slashBrush2
  $slashT = New-Object System.Windows.Media.TranslateTransform
  $slashR = New-Object System.Windows.Media.RotateTransform
  $slashG = New-Object System.Windows.Media.TransformGroup
  $slashG.Children.Add($slashT) | Out-Null
  $slashG.Children.Add($slashR) | Out-Null
  $slash.RenderTransform = $slashG
  $burstCanvas.Children.Add($slash) | Out-Null
  $script:slashes += ,@($slash, $slashT, $slashR)
}
$slash0 = $script:slashes[0][0]
$slash0.Width = 512
$slash0.Height = 5
$slash0T = $script:slashes[0][1]
$slash0R = $script:slashes[0][2]
$slash0R.Angle = -14
[System.Windows.Controls.Canvas]::SetLeft($slash0, -96)
[System.Windows.Controls.Canvas]::SetTop($slash0, 96)
$slash1 = $script:slashes[1][0]
$slash1.Width = 512
$slash1.Height = 5
$slash1T = $script:slashes[1][1]
$script:slashes[1][2].Angle = 9
[System.Windows.Controls.Canvas]::SetLeft($slash1, -96)
[System.Windows.Controls.Canvas]::SetTop($slash1, 198)
$slash2 = $script:slashes[2][0]
$slash2.Width = 5
$slash2.Height = 448
$slash2T = $script:slashes[2][1]
$script:slashes[2][2].Angle = 18
[System.Windows.Controls.Canvas]::SetLeft($slash2, 32)
[System.Windows.Controls.Canvas]::SetTop($slash2, -64)

# 冰晶粒子
$script:particles = @()
for ($i = 0; $i -lt 18; $i++) {
  $p = New-Object System.Windows.Shapes.Ellipse
  $p.Width = 10
  $p.Height = 10
  $p.Fill = New-Solid 255 190 230 255
  $p.Effect = New-Object System.Windows.Media.Effects.DropShadowEffect
  $p.Effect.BlurRadius = 8
  $p.Effect.ShadowDepth = 0
  $p.Effect.Color = [System.Windows.Media.Color]::FromArgb(255, 150, 215, 255)
  $p.Opacity = 0
  $pT = New-Object System.Windows.Media.TranslateTransform
  $p.RenderTransform = $pT
  [System.Windows.Controls.Canvas]::SetLeft($p, 155)
  [System.Windows.Controls.Canvas]::SetTop($p, 155)
  $burstCanvas.Children.Add($p) | Out-Null
  $script:particles += ,@($p, $pT)
}

# ---------- 爆发 ----------
function Invoke-Burst {
  try { $script:player.Play() } catch { }
  # 闪光（0→1→0）
  $script:flashRect.BeginAnimation([System.Windows.UIElement]::OpacityProperty, (New-DoubleAnim 0 1 300 $true))
  # 冲击波
  $script:ringScale.BeginAnimation([System.Windows.Media.ScaleTransform]::ScaleXProperty, (New-DoubleAnim 0.2 2.1 700 $false))
  $script:ringScale.BeginAnimation([System.Windows.Media.ScaleTransform]::ScaleYProperty, (New-DoubleAnim 0.2 2.1 700 $false))
  $script:ring.BeginAnimation([System.Windows.UIElement]::OpacityProperty, (New-DoubleAnim 0.95 0 700 $false))
  # 斩光
  $a1 = New-DoubleAnim 0 170 550 $false
  $a1.BeginTime = [TimeSpan]::FromMilliseconds(50)
  $slash0T.BeginAnimation([System.Windows.Media.TranslateTransform]::XProperty, $a1)
  $f1 = New-Frames 550
  Add-KeyFrame $f1 0 0; Add-KeyFrame $f1 1 0.15; Add-KeyFrame $f1 0 1
  Animate-Opacity $slash0 $f1
  $a2 = New-DoubleAnim 0 -170 550 $false
  $a2.BeginTime = [TimeSpan]::FromMilliseconds(120)
  $slash1T.BeginAnimation([System.Windows.Media.TranslateTransform]::XProperty, $a2)
  $f2 = New-Frames 550
  Add-KeyFrame $f2 0 0; Add-KeyFrame $f2 1 0.15; Add-KeyFrame $f2 0 1
  Animate-Opacity $slash1 $f2
  $a3 = New-DoubleAnim 80 -150 600 $false
  $a3.BeginTime = [TimeSpan]::FromMilliseconds(180)
  $slash2T.BeginAnimation([System.Windows.Media.TranslateTransform]::YProperty, $a3)
  $f3 = New-Frames 600
  Add-KeyFrame $f3 0 0; Add-KeyFrame $f3 1 0.15; Add-KeyFrame $f3 0 1
  Animate-Opacity $slash2 $f3
  # 粒子
  for ($i = 0; $i -lt $script:particles.Count; $i++) {
    $p = $script:particles[$i][0]
    $pT = $script:particles[$i][1]
    $dx = ((($i % 5) - 2) * 100 + (($i * 13) % 19) - 9)
    $dy = ((([math]::Floor($i / 5) % 3) - 1) * 118 - 70)
    $delay = [TimeSpan]::FromMilliseconds(($i % 4) * 30)
    $px = New-DoubleAnim 0 $dx 800 $false
    $px.BeginTime = $delay
    $py = New-DoubleAnim 0 $dy 800 $false
    $py.BeginTime = $delay
    $pT.BeginAnimation([System.Windows.Media.TranslateTransform]::XProperty, $px)
    $pT.BeginAnimation([System.Windows.Media.TranslateTransform]::YProperty, $py)
    $pf = New-Frames 800
    Add-KeyFrame $pf 0 0; Add-KeyFrame $pf 1 0.12; Add-KeyFrame $pf 0 1
    $p.BeginAnimation([System.Windows.UIElement]::OpacityProperty, $pf)
  }
  # 抖动（关键帧回到 0，不留偏移）
  $sx = New-Frames 550
  Add-KeyFrame $sx 0 0; Add-KeyFrame $sx -12 0.15; Add-KeyFrame $sx 12 0.3
  Add-KeyFrame $sx -10 0.45; Add-KeyFrame $sx 9 0.6; Add-KeyFrame $sx -4 0.8; Add-KeyFrame $sx 0 1
  $script:shakeX.BeginAnimation([System.Windows.Media.TranslateTransform]::XProperty, $sx)
  $sy = New-Frames 550
  Add-KeyFrame $sy 0 0; Add-KeyFrame $sy -6 0.15; Add-KeyFrame $sy 6 0.3
  Add-KeyFrame $sy -5 0.45; Add-KeyFrame $sy 5 0.6; Add-KeyFrame $sy -2 0.8; Add-KeyFrame $sy 0 1
  $script:shakeY.BeginAnimation([System.Windows.Media.TranslateTransform]::YProperty, $sy)
  # 字幕
  $sf = New-Frames 950
  Add-KeyFrame $sf 0 0; Add-KeyFrame $sf 1 0.2; Add-KeyFrame $sf 1 0.7; Add-KeyFrame $sf 0 1
  Animate-Opacity $script:skillLabel $sf
  $lf = New-Frames 1900
  Add-KeyFrame $lf 0 0; Add-KeyFrame $lf 1 0.12; Add-KeyFrame $lf 1 0.8; Add-KeyFrame $lf 0 1
  Animate-Opacity $script:lineLabel $lf
}

# ---------- 拖动（主窗口卡片） ----------
$script:drag = $null
$card.Add_MouseLeftButtonDown({
  param($s, $e)
  $script:drag = @{
    sx = $e.GetPosition($script:win).X
    sy = $e.GetPosition($script:win).Y
    L = $script:win.Left
    T = $script:win.Top
    moved = $false
  }
  $card.CaptureMouse() | Out-Null
})
$card.Add_MouseMove({
  param($s, $e)
  if ($null -eq $script:drag) { return }
  $p = $e.GetPosition($script:win)
  $dx = $p.X - $script:drag.sx
  $dy = $p.Y - $script:drag.sy
  if (([math]::Abs($dx) + [math]::Abs($dy)) -gt 6) { $script:drag.moved = $true }
  $script:win.Left = $script:drag.L + $dx
  $script:win.Top = $script:drag.T + $dy
})
$card.Add_MouseLeftButtonUp({
  param($s, $e)
  $card.ReleaseMouseCapture()
  if ($null -ne $script:drag -and -not $script:drag.moved) { Invoke-Burst }
  $script:drag = $null
})

# ============================================================
# 胶囊窗口
# ============================================================
$script:pillWin = New-Object System.Windows.Window
$script:pillWin.Width = 140
$script:pillWin.Height = 48
$script:pillWin.WindowStyle = [System.Windows.WindowStyle]::None
$script:pillWin.AllowsTransparency = $true
$script:pillWin.Background = [System.Windows.Media.Brushes]::Transparent
$script:pillWin.Topmost = $true
$script:pillWin.ShowInTaskbar = $false
$script:pillWin.ResizeMode = [System.Windows.ResizeMode]::NoResize
$script:pillWin.Left = $startLeft
$script:pillWin.Top = $startTop

$pill = New-Object System.Windows.Controls.Border
$pill.CornerRadius = New-Object System.Windows.CornerRadius(23)
$pill.Background = New-Solid 230 12 22 40
$pill.BorderBrush = New-Solid 140 150 200 255
$pill.BorderThickness = New-Object System.Windows.Thickness(1)
$pill.Effect = New-Object System.Windows.Media.Effects.DropShadowEffect
$pill.Effect.BlurRadius = 12
$pill.Effect.ShadowDepth = 3
$pill.Effect.Opacity = 0.5
$pillLabel = New-Object System.Windows.Controls.TextBlock
$pillLabel.Text = '丝柯克 ✦'
$pillLabel.FontFamily = 'Microsoft YaHei'
$pillLabel.FontSize = 16
$pillLabel.FontWeight = 'Bold'
$pillLabel.Foreground = New-Solid 255 214 236 255
$pillLabel.HorizontalAlignment = 'Center'
$pillLabel.VerticalAlignment = 'Center'
$pill.Child = $pillLabel
$script:pillWin.Content = $pill

$script:pillDrag = $null
$pill.Add_MouseLeftButtonDown({
  param($s, $e)
  $script:pillDrag = @{
    sx = $e.GetPosition($script:pillWin).X
    sy = $e.GetPosition($script:pillWin).Y
    L = $script:pillWin.Left
    T = $script:pillWin.Top
    moved = $false
  }
  $pill.CaptureMouse() | Out-Null
})
$pill.Add_MouseMove({
  param($s, $e)
  if ($null -eq $script:pillDrag) { return }
  $p = $e.GetPosition($script:pillWin)
  $dx = $p.X - $script:pillDrag.sx
  $dy = $p.Y - $script:pillDrag.sy
  if (([math]::Abs($dx) + [math]::Abs($dy)) -gt 6) { $script:pillDrag.moved = $true }
  $script:pillWin.Left = $script:pillDrag.L + $dx
  $script:pillWin.Top = $script:pillDrag.T + $dy
})
$pill.Add_MouseLeftButtonUp({
  param($s, $e)
  $pill.ReleaseMouseCapture()
  if ($null -ne $script:pillDrag -and -not $script:pillDrag.moved) { Show-Skin }
  $script:pillDrag = $null
})

# ---------- 收起/显示 ----------
function Show-Pill {
  $script:pillWin.Left = $script:win.Left
  $script:pillWin.Top = $script:win.Top
  $script:win.Hide()
  $script:pillWin.Show()
  $script:pillWin.Activate()
}
function Show-Skin {
  $script:win.Left = $script:pillWin.Left
  $script:win.Top = $script:pillWin.Top
  $script:pillWin.Hide()
  $script:win.Show()
  $script:win.Activate()
}

# ---------- 开机自启 ----------
function Get-AutoStart { return (Test-Path ($script:runKeyPath + '\' + $script:runValueName)) }
function Set-AutoStart([bool]$enable) {
  if ($enable) { Set-ItemProperty -Path $script:runKeyPath -Name $script:runValueName -Value $script:launchCmd }
  else { Remove-ItemProperty -Path $script:runKeyPath -Name $script:runValueName -ErrorAction SilentlyContinue }
}

# ---------- 退出 / 卸载 ----------
function Invoke-Exit {
  $script:menuWin.Hide()
  $script:player.Dispose()
  $script:win.Close()
  $script:pillWin.Close()
  [System.Windows.Threading.Dispatcher]::CurrentDispatcher.InvokeShutdown()
}
function Invoke-Uninstall {
  $script:menuWin.Hide()
  $res = [System.Windows.MessageBox]::Show(
    ('确定卸载丝柯克桌面皮肤吗？' + [char]10 + '将关闭程序、移除开机自启，并删除本桌面版文件夹。'),
    '丝柯克皮肤 · 一键卸载',
    [System.Windows.MessageBoxButton]::YesNo,
    [System.Windows.MessageBoxImage]::Warning)
  if ($res -ne [System.Windows.MessageBoxResult]::Yes) { return }
  Set-AutoStart $false
  $script:player.Dispose()
  $dir = $PSScriptRoot
  $del = '/c timeout /t 2 /nobreak >nul & del /f /q "' + $dir + '\*" & rd /s /q "' + $dir + '"'
  Start-Process -FilePath 'cmd.exe' -ArgumentList $del -WindowStyle Hidden
  $script:win.Close()
  $script:pillWin.Close()
  [System.Windows.Threading.Dispatcher]::CurrentDispatcher.InvokeShutdown()
  exit 0
}

# ============================================================
# 独立菜单窗口（置顶，避免 ContextMenu 被主窗口压住）
# ============================================================
$script:menuMode = 'card'
$script:menuWin = New-Object System.Windows.Window
$script:menuWin.Width = 216
$script:menuWin.Height = 200
$script:menuWin.WindowStyle = [System.Windows.WindowStyle]::None
$script:menuWin.AllowsTransparency = $true
$script:menuWin.Background = [System.Windows.Media.Brushes]::Transparent
$script:menuWin.Topmost = $true
$script:menuWin.ShowInTaskbar = $false
$script:menuWin.ResizeMode = [System.Windows.ResizeMode]::NoResize
$script:menuWin.ShowActivated = $false
$script:menuWin.Add_Deactivated({ $script:menuWin.Hide() })

$menuPanel = New-Object System.Windows.Controls.Border
$menuPanel.CornerRadius = New-Object System.Windows.CornerRadius(12)
$menuPanel.Background = New-Solid 245 10 18 32
$menuPanel.BorderBrush = New-Solid 100 150 200 255
$menuPanel.BorderThickness = New-Object System.Windows.Thickness(1)
$menuPanel.Padding = New-Object System.Windows.Thickness(6)
$menuStack = New-Object System.Windows.Controls.StackPanel
$menuPanel.Child = $menuStack
$script:menuWin.Content = $menuPanel

function Add-MenuButton($label, $isDanger, $action) {
  $b = New-Object System.Windows.Controls.Button
  $b.Content = $label
  $b.Background = [System.Windows.Media.Brushes]::Transparent
  $b.BorderThickness = New-Object System.Windows.Thickness(0)
  $b.HorizontalContentAlignment = 'Left'
  $b.Padding = New-Object System.Windows.Thickness(12, 9, 12, 9)
  $b.FontFamily = 'Microsoft YaHei'
  $b.FontSize = 13
  $b.Cursor = 'Hand'
  if ($isDanger) { $b.Foreground = New-Solid 255 255 180 168 } else { $b.Foreground = New-Solid 255 214 236 255 }
  $b.Add_MouseEnter({ $_.Source.Background = New-Solid 90 50 90 180 })
  $b.Add_MouseLeave({ $_.Source.Background = [System.Windows.Media.Brushes]::Transparent })
  $clickHandler = { $script:menuWin.Hide(); & $action }.GetNewClosure()
  $b.Add_Click($clickHandler)
  $menuStack.Children.Add($b) | Out-Null
  return $b
}
function Add-MenuSep {
  $sep = New-Object System.Windows.Controls.Border
  $sep.Height = 1
  $sep.Margin = New-Object System.Windows.Thickness(6, 4, 6, 4)
  $sep.Background = New-Solid 45 150 200 255
  $menuStack.Children.Add($sep) | Out-Null
}
function Show-Menu([string]$mode, [double]$x, [double]$y) {
  $script:menuMode = $mode
  $menuStack.Children.Clear()
  Add-MenuButton '释放元素爆发「极恶技·灭」' $false { Invoke-Burst } | Out-Null
  if ($mode -eq 'card') { Add-MenuButton '收起皮肤' $false { Show-Pill } | Out-Null }
  else { Add-MenuButton '显示皮肤' $false { Show-Skin } | Out-Null }
  $autoOn = Get-AutoStart
  Add-MenuButton ('开机自启：' + $(if ($autoOn) { '已开启' } else { '已关闭' })) $false { if (Get-AutoStart) { Set-AutoStart $false } else { Set-AutoStart $true } } | Out-Null
  Add-MenuSep
  Add-MenuButton '一键卸载' $true { Invoke-Uninstall } | Out-Null
  Add-MenuButton '退出' $false { Invoke-Exit } | Out-Null
  $script:menuWin.Left = [Math]::Min($x, $screen.Right - 226)
  $script:menuWin.Top = [Math]::Min($y, $screen.Bottom - 210)
  $script:menuWin.Show()
  $script:menuWin.Activate()
}

$card.Add_MouseRightButtonUp({
  param($s, $e)
  $pt = $script:win.PointToScreen($e.GetPosition($script:win))
  Show-Menu 'card' $pt.X $pt.Y
})
$pill.Add_MouseRightButtonUp({
  param($s, $e)
  $pt = $script:pillWin.PointToScreen($e.GetPosition($script:pillWin))
  Show-Menu 'pill' $pt.X $pt.Y
})

# ---------- 常驻浮动 ----------
$bobAnim = New-DoubleAnim 0 -7 1800 $true
$bobAnim.RepeatBehavior = [System.Windows.Media.Animation.RepeatBehavior]::Forever
$script:bobY.BeginAnimation([System.Windows.Media.TranslateTransform]::YProperty, $bobAnim)

# ---------- 显示 ----------
$script:win.Show()
$script:win.Activate()
[System.Windows.Threading.Dispatcher]::Run()
