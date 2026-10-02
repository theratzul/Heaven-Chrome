@echo off
REM ============================================
REM  Chronos - Run Script
REM  Builds and launches in Fuse emulator
REM ============================================

call "%~dp0build.bat"

if %ERRORLEVEL% EQU 0 (
    echo  Launching in Fuse emulator...
    if exist "%~dp0tools\fuse\fuse.exe" (
        start "" /D "%~dp0tools\fuse" "%~dp0tools\fuse\fuse.exe" --machine 48 --tape "%~dp0build\chronos.tap"
    ) else (
        echo.
        echo  Fuse emulator not found at tools\fuse\fuse.exe
        echo  Please install Fuse or open build\chronos.tap manually.
        echo  Download: https://fuse-emulator.sourceforge.net/
        echo.
    )
)
