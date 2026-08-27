# 丝柯克（Skirk）动态皮肤 · VSCode / Trae 扩展

在 VSCode / Trae-IDE 侧边栏显示原神丝柯克动态皮肤：点击播放大招中文语音「沉于渊海。」+ 爆发动画；胶囊右键「一键卸载」。

## 安装

方式一：源码直装（开发模式）
1. 把本文件夹放到任意位置
2. VSCode / Trae：`扩展 → 从 VSIX 安装…`（先打包，见方式二）；或 `code --install-extension 打包好的.vsix`

方式二：使用仓库内已打包好的 VSIX（推荐）
1. 从 GitHub 仓库 `vscode-extension/genshen-skirk-skin-1.0.0.vsix` 下载 VSIX 文件
2. VSCode / Trae：`扩展 → … 菜单 → 从 VSIX 安装`，选中该文件
（也可以直接命令行：`code --install-extension genshen-skirk-skin-1.0.0.vsix`）

方式三：重新打包 VSIX
1. 已安装 Node.js / npm 的环境双击 `build.bat`（内部执行 `npm install -g @vscode/vsce` + `vsce package`）
2. 生成 `genshen-skirk-skin-1.0.0.vsix`
3. 按方式二安装

方式四：临时试用（不改系统）
- 命令行进入本文件夹执行 `code --extensionDevelopmentPath="."`（Trae 同理）

## 使用

- 命令面板（Ctrl+Shift+P）运行「丝柯克皮肤：显示」
- 皮肤面板：左键点击 = 释放元素爆发；拖动 = 移动；右键 = 菜单（释放/收起/一键卸载）
- 收起后为“丝柯克 ✦”胶囊，胶囊右键 → **一键卸载**（走 VSCode 扩展卸载流程，确认后重启生效）

## 说明

- 素材（立绘/语音）版权归米哈游，仅供个人学习娱乐（见 LICENSE.txt）
- 若卸载按钮未弹出确认框，请在扩展面板中手动卸载
