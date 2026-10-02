@echo off
REM ============================================
REM  Chronos - Environment Setup
REM  Sets up z88dk paths for building
REM ============================================

set CHRONOS_ROOT=%~dp0
set Z88DK=%CHRONOS_ROOT%tools\z88dk\z88dk
set ZCCCFG=%Z88DK%\lib\config
set Z80_OZFILES=%Z88DK%\lib\clibs
set PATH=%Z88DK%\bin;%PATH%

if not exist "%CHRONOS_ROOT%build\tmp" mkdir "%CHRONOS_ROOT%build\tmp"
set TEMP=%CHRONOS_ROOT%build\tmp
set TMP=%CHRONOS_ROOT%build\tmp

echo.
echo  ========================================
echo   Chronos Development Environment
echo  ========================================
echo.
echo  Z88DK:     %Z88DK%
echo  ZCCCFG:    %ZCCCFG%
echo  Project:   %CHRONOS_ROOT%
echo.
echo  Ready to build. Run build.bat to compile.
echo.
