# Genshen-Skirk-Skin · 原神丝柯克动态皮肤

点击皮肤即可释放元素爆发「极恶技·灭」——播放中文大招语音「**沉于渊海。**」+ 爆发动作动画（冰蓝闪光、冲击波、三连斩光、冰晶碎屑、技能名与台词字幕）。支持拖动、收起为胶囊，胶囊/皮肤**右键一键卸载**。

## 🤖 一句话 AI 安装（推荐）

把本仓库地址发给任意 AI 助手（DeepSeek Harness / claude-code / CodeX / kimi-code / VSCode 里的 Copilot 等），说：

> 安装这个丝柯克皮肤：https://github.com/WPH666-py/Genshen-Skirk-Skin

AI 会读取本仓库的 [`AGENTS.md`](AGENTS.md)，自动识别你所在的环境（DSH / VSCode / 其他终端）并完成安装，无需手动复制任何文件。

## 平台适配

| 平台 | 目录 | 形态 | 一键卸载 |
| --- | --- | --- | --- |
| DeepSeek Harness（DSH 网页/桌面） | [`dsh-plugin/`](dsh-plugin) | 动态 Cordis 插件（零配置，素材内嵌） | 皮肤右键 → 一键卸载（UI/路由立即移除；彻底删除记录对 AI 说 `cordis_undefine`） |
| VSCode / Trae-IDE | [`vscode-extension/`](vscode-extension) | 侧边栏 Webview 扩展（**已附现成 VSIX**） | 胶囊右键 → 一键卸载（VSCode 扩展卸载流程） |
| Windows 桌面（任意编辑器之上） | [`desktop/`](desktop) | 置顶透明悬浮窗（PowerShell+WPF，免安装） | 右键 → 一键卸载（移除开机自启并删除文件夹） |

> **PyCharm、WebStorm**（JetBrains 系）与 **claude-code、CodeX、kimi-code** 等终端/CLI 工具：使用 [`desktop/`](desktop) 桌面悬浮版，皮肤悬浮于任何应用之上，无需各编辑器原生插件即可通用；原生集成可按需扩展。

## 手动快速开始

**DeepSeek Harness**：把 `dsh-plugin/client.js` 内容用 `cordis_define` 粘到 `code.client`（可选 `host.js` 全画质模式），再 `cordis_run` 授权即可。

**VSCode / Trae**：下载 `vscode-extension/genshen-skirk-skin-1.0.0.vsix` 后 `code --install-extension genshen-skirk-skin-1.0.0.vsix`（重新打包用 `build.bat`）。

**PC 桌面**：双击 `desktop/启动-丝柯克皮肤.bat`；右键菜单勾选「开机自启」可随系统启动。

## 目录

```
├── AGENTS.md              AI 助手自动安装指令（claude-code/CodeX/kimi-code/Copilot 等自动读取）
├── dsh-plugin/            DeepSeek Harness 动态插件（client.js 零配置 + host.js 可选全画质 + 素材）
├── vscode-extension/      VSCode / Trae 扩展（现成 VSIX + webview 皮肤 + 右键卸载）
├── desktop/               Windows 桌面悬浮版（置顶透明窗口，覆盖所有应用）
├── 版权说明.md             素材版权与使用声明
└── README.md
```

## 说明

- 丝柯克立绘与语音素材来自《原神》，版权归米哈游（miHoYo / HoYoverse）所有，**仅供个人学习娱乐，禁止商用**（见 [`版权说明.md`](版权说明.md)）。
- 语音台词为元素爆发「极恶技·灭」其一「沉于渊海。」（其余 4 条备选见各平台 README）。
