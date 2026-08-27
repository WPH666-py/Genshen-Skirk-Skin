@echo off
rem 丝柯克（Skirk）桌面皮肤启动器
rem 右键本文件 -> 发送到 -> 桌面快捷方式，即可一键启动
start "" powershell.exe -NoProfile -STA -ExecutionPolicy Bypass -WindowStyle Hidden -File "%~dp0丝柯克皮肤.ps1"
exit /b 0
