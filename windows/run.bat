@echo off
REM ========================================================
REM  Heaven Chrome - Windows 11 Native Launcher
REM ========================================================

cd /d "%~dp0"

if exist "heaven-chrome.exe" (
    start "" "heaven-chrome.exe" %*
) else if exist "bin\heaven-chrome.exe" (
    start "" "bin\heaven-chrome.exe" %*
) else (
    echo Error: heaven-chrome.exe not found!
    pause
)
