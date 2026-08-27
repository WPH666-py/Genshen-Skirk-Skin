# AGENTS.md — 丝柯克皮肤自动安装指令（AI 助手必读）

当用户把本仓库地址交给你并要求“安装丝柯克皮肤 / 装这个皮肤”时，按下面的步骤执行。所有素材均已内嵌在对应文件里（base64），**不要修改或截断任何 base64 内容**。

## 第 1 步：识别用户环境

- 你能调用 `cordis_define` / `cordis_run` 工具 → **DeepSeek Harness**，执行「A」。
- 你能执行 `code` / `trae` 命令行（VSCode / Trae 环境）→ 执行「B」。
- 其他情况（claude-code、CodeX、kimi-code、JetBrains、普通终端等）→ 执行「C」。

## A. DeepSeek Harness（动态 Cordis 插件）

1. 下载并读取 `https://raw.githubusercontent.com/WPH666-py/Genshen-Skirk-Skin/main/dsh-plugin/client.js` 的完整内容（约 190 KB，图片与语音已内嵌为 base64，无需下载素材文件）。
2. 调用 `cordis_define`：
   - `plugin.kind = "new"`，`idPrefix = "skirk"`
   - `code.client` = 上一步读到的 client.js 完整内容
   - `code.host` 不填（零配置模式）
3. 调用 `cordis_run`，`mode = "run"`，使用 define 返回的 `pluginId` / `packageId`。
4. 告知用户：页面右下角出现丝柯克皮肤，点击释放元素爆发「极恶技·灭」（中文语音+动画）；皮肤/胶囊右键菜单含「一键卸载」。
5. 若用户要求**原图画质**：把 `dsh-plugin/host.js` 内容填入 `code.host` 一起 define，并先把其中 `ASSET_DIR` 改为 `dsh-plugin/素材` 文件夹在用户机器上的绝对路径。

## B. VSCode / Trae

1. 下载 `https://raw.githubusercontent.com/WPH666-py/Genshen-Skirk-Skin/main/vscode-extension/genshen-skirk-skin-1.0.0.vsix` 到本地临时目录（仓库内已附打包好的 VSIX）。
2. 执行安装：
   - VSCode：`code --install-extension <vsix 完整路径>`
   - Trae：`trae --install-extension <vsix 完整路径>`；若无 trae CLI，则把 VSIX 解压到 `%USERPROFILE%\.vscode\extensions\wp666.genshen-skirk-skin-1.0.0\`（Trae 亦兼容 .vscode 扩展目录），并提示用户重启编辑器。
3. 告知用户：命令面板（Ctrl+Shift+P）运行「丝柯克皮肤：显示」；皮肤右键菜单含「一键卸载」（走 VSCode 扩展卸载流程）。

## C. 其他环境（claude-code / CodeX / kimi-code / JetBrains / 任意 Windows 桌面）

桌面悬浮版悬浮于一切应用之上，覆盖所有编辑器：

1. 下载 `desktop/` 目录下的全部文件到本地目录（例如 `%USERPROFILE%\Genshen-Skirk-Skin-desktop`，需保留 `素材/` 子目录结构）。
2. 在 Windows 上后台启动：`start "" powershell.exe -NoProfile -STA -ExecutionPolicy Bypass -File "<目录>\丝柯克皮肤.ps1"`（或运行同目录 `启动-丝柯克皮肤.bat`）。
3. 告知用户：右下角出现悬浮皮肤，左键点击释放大招（语音+动画），可拖动；右键菜单含「开机自启」与「一键卸载」（卸载会移除自启并删除该目录）。

## 约束与失败处理

- 任何下载内容中 `data:image/jpeg;base64,` / `data:audio/ogg;base64,` 之后的长串**不得删改、换行或截断**。
- 下载失败 → 重试一次；仍失败 → 告知用户网络问题并给出手动安装链接（README 中的「快速开始」）。
- 非 Windows 桌面环境：告知用户当前桌面悬浮版仅支持 Windows，DSH 插件与 VSCode 扩展跨平台可用。
- 素材版权归米哈游（miHoYo/HoYoverse），仅供个人学习娱乐，用户问及商用时如实说明。
