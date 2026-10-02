@echo off
REM ============================================
REM  Chronos - Build Script
REM  Compiles the game using z88dk
REM ============================================

call "%~dp0env.bat"

echo  Building Chronos...
echo.

REM Compile with z88dk classic library targeting ZX Spectrum
zcc +zx -vn -startup=1 ^
    -clib=sdcc_iy ^
    -SO3 --max-allocs-per-node200000 ^
    --opt-code-speed ^
    -pragma-define:CRT_ORG_CODE=0x8000 ^
    -pragma-define:REGISTER_SP=0xD000 ^
    -pragma-define:CRT_STACK_SIZE=512 ^
    src/game/main.c ^
    src/game/player.c ^
    src/game/levels.c ^
    src/game/chrono.c ^
    src/game/hud.c ^
    src/engine/sprites.asm ^
    src/engine/video.asm ^
    src/engine/input.asm ^
    src/engine/sound.asm ^
    src/engine/isr.asm ^
    -o build/chronos ^
    -create-app

if %ERRORLEVEL% EQU 0 (
    echo.
    echo  ========================================
    echo   BUILD SUCCESSFUL
    echo  ========================================
    echo   Output: build\chronos.tap
    echo  ========================================
) else (
    echo.
    echo  !! BUILD FAILED !!
    echo.
)
