@echo off
REM ========================================================
REM  Heaven Chrome - Windows 11 Build Script
REM ========================================================

cd /d "%~dp0windows"
echo Building Heaven Chrome Windows 11...

if not exist bin mkdir bin

windres -i resource.rc -o resource.res.o
gcc -O2 -Wall -Wextra -std=c99 -Iinclude -Llib src/main.c src/game.c src/render.c src/audio.c resource.res.o -lmingw32 -lSDL2main -lSDL2 -mwindows -lm -o bin\heaven-chrome.exe

if exist bin\heaven-chrome.exe (
    copy /Y lib\SDL2.dll bin\SDL2.dll
    copy /Y steam_appid.txt bin\steam_appid.txt
    echo Build Successful: windows\bin\heaven-chrome.exe
) else (
    echo Build Failed!
)
