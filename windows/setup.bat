@echo off
REM ========================================================
REM  Heaven Chrome - Windows 11 Setup & Shortcut Creator
REM ========================================================

echo ===================================================
echo   Installing Heaven Chrome for Windows 11
echo ===================================================

set SCRIPT_DIR=%~dp0
set TARGET_EXE=%SCRIPT_DIR%bin\heaven-chrome.exe
if not exist "%TARGET_EXE%" set TARGET_EXE=%SCRIPT_DIR%heaven-chrome.exe
set ICON_PATH=%SCRIPT_DIR%icon.ico

if not exist "%TARGET_EXE%" (
    echo Error: heaven-chrome.exe not found!
    pause
    exit /b 1
)

echo Target: %TARGET_EXE%
echo Icon:   %ICON_PATH%

REM Create Desktop Shortcut via VBScript
set VBS_SCRIPT=%TEMP%\create_hc_shortcut.vbs
echo Set oWS = WScript.CreateObject("WScript.Shell") > "%VBS_SCRIPT%"
echo sLinkFile = oWS.SpecialFolders("Desktop") ^& "\Heaven Chrome.lnk" >> "%VBS_SCRIPT%"
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> "%VBS_SCRIPT%"
echo oLink.TargetPath = "%TARGET_EXE%" >> "%VBS_SCRIPT%"
echo oLink.WorkingDirectory = "%SCRIPT_DIR%" >> "%VBS_SCRIPT%"
echo oLink.Description = "Heaven Chrome - A Divine Time-Bending Journey" >> "%VBS_SCRIPT%"
echo oLink.IconLocation = "%ICON_PATH%, 0" >> "%VBS_SCRIPT%"
echo oLink.Save >> "%VBS_SCRIPT%"

cscript /nologo "%VBS_SCRIPT%"
del "%VBS_SCRIPT%"

echo [OK] Desktop Shortcut created successfully!
echo [OK] Windows 11 Setup complete. You can now launch Heaven Chrome from your Desktop.
echo.
pause
