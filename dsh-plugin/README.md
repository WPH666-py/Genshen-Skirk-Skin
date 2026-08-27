# 丝柯克（Skirk）动态皮肤插件 · 独立版

一个**自包含**的原神丝柯克动态皮肤插件，适用于任何 [DeepSeek Harness](https://www.deepseek.com/)（DSH）环境（桌面版 / 网页版均可）。任何拿到本文件夹的人都能直接安装使用。

## 效果

- 页面右下角出现 320px 丝柯克皮肤挂件，可拖拽、可收起（× → “丝柯克 ✦”胶囊），常态轻微浮动
- **点击皮肤**：播放元素爆发「极恶技·灭」中文大招语音（其一「**沉于渊海。**」），同时播放爆发动作动画——冰蓝闪光、冲击波、三连斩光、冰晶碎屑飞散、技能名与台词字幕
- 连续点击可重复触发；语音每次只播一条

## 文件说明

```
丝柯克动态皮肤插件（独立版）/
├── client.js    ← 客户端源码（素材已内嵌，零配置，直接可用）★核心
├── host.js      ← 可选 Host：全画质模式用（原图 960×1280）
├── README.md    ← 本说明
└── 素材/
    ├── 丝柯克.png                 原图（全画质模式使用）
    ├── 丝柯克-web.jpg            网页优化图（已内嵌进 client.js）
    └── 语音-元素爆发·沉于渊海.mp3 中文大招语音（已内嵌进 client.js）
```

## 安装方式 A：零配置（推荐，只需 client.js）

1. 打开任意一个 DSH 会话（保证当前就是可运行动态插件的 Cordis 环境）。
2. 新建动态插件：`cordis_define`，`plugin.kind: "new"`，`idPrefix` 填 `skirk`（或任意 3–6 位小写字母），把 `client.js` 的**全部内容**粘贴到 `code.client`（约 180KB，粘贴稍慢属正常）。
3. `cordis_run`（mode: `run`），在弹出的授权卡片上点击允许。
4. 完成：右下角即出现皮肤挂件，点击即可听语音看大招。

> 如果你更习惯“说一句话让 AI 助手来做”：把本文件夹发给助手，并说：
> “把 client.js 的内容用 cordis_define 定义为新插件并 cordis_run 运行”。

## 安装方式 B：全画质模式（client.js + host.js，可选）

想用 960×1280 原图（而非内嵌的 640px 优化图）时：

1. 编辑 `host.js` 第一段中的 `ASSET_DIR`，改成素材文件夹在你机器上的绝对路径，例如：
   `const ASSET_DIR = 'C:/Users/你的名字/Downloads/丝柯克动态皮肤插件（独立版）/素材'`
2. `cordis_define` 时把 `host.js` 粘贴到 `code.host`、`client.js` 粘贴到 `code.client`，然后 `cordis_run`。
3. 客户端会自动检测到 Host 并切换到原图素材；图片加载失败时会显示 ⚠ 角标（通常说明 `ASSET_DIR` 路径不对）。

## 自定义

| 想改什么 | 改哪里 |
| --- | --- |
| 挂件尺寸（默认 320px） | `client.js` 中 CSS 的 `.skirk-card` / `.skirk-img` 宽高（特效可按比例缩放） |
| 默认位置（右下角） | `SkirkWidget` 里 `pos` 的初始 x/y |
| 语音台词 | `client.js` 中 `VOICE_TEXT`；替换语音见下 |
| 收起后胶囊文案 | `.skirk-pill` 渲染的文本“丝柯克 ✦” |

### 更换大招语音（一条）

把新 mp3 转成 base64（PowerShell，MIME 按新文件实际格式选：MP3 用 `audio/mpeg`，OGG 用 `audio/ogg`；本插件自带语音实际是 OGG 容器）：

```powershell
$b = [Convert]::ToBase64String([System.IO.File]::ReadAllBytes('新语音.mp3'))
"data:audio/ogg;base64,$b"
```

把输出整行替换 `client.js` 开头的 `const BURST_DATA_URI = '...'` 即可。丝柯克其余 4 条中文大招语音（元素爆发「极恶技·灭」其二~其五）：

- 其二「群星寂灭。」 https://patchwiki.biligame.com/images/ys/d/d6/ahxavaqiquukqr46zvanz85wvfdczxs.mp3
- 其三「更迭万象。」 https://patchwiki.biligame.com/images/ys/6/6f/pd5crm7nfdr98opxrb3sjysrlj837xt.mp3
- 其四「力量啊…」 https://patchwiki.biligame.com/images/ys/3/34/p2a7q66jma03f7ow8l6axnihowi5pe9.mp3
- 其五「归于我。」 https://patchwiki.biligame.com/images/ys/2/2c/6cf38xnkj3xb6iy12p9c5stal6s154v.mp3

## 常见问题

- **重启后插件没了？** 动态插件只存在于进程内，重启后按安装方式 A 重新 define/run 一次即可（可以让 AI 助手代劳）。
- **点了没声音？** 确认浏览器没有全局静音；语音由点击手势触发，一般不受自动播放策略限制。若仍无声，检查 `client.js` 里 `BURST_DATA_URI` 是否完整。
- **全画质模式图片不显示？** 检查 `ASSET_DIR` 路径与文件名（含中文括号），并确认 Host 与 Client 是同一个插件包的同一版本。

## 版权说明

丝柯克立绘与语音素材版权归米哈游（miHoYo/HoYoverse）所有，本插件仅供个人学习与娱乐使用，请勿用于商业用途。
