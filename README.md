# Chronos - ZX Spectrum Game

A time-manipulation action game for the ZX Spectrum 48K, written in Z80 assembly
with C game logic using the **z88dk** cross-compiler.

## Project Structure

```
Chronos/
+-- src/
|   +-- engine/         # Low-level engine (ASM routines)
|   |   +-- video.asm   # Screen/attribute buffer helpers
|   |   +-- input.asm   # Keyboard input routines
|   |   +-- sound.asm   # Beeper sound routines
|   |   +-- sprites.asm # Sprite drawing routines
|   |   +-- isr.asm     # IM2 interrupt-driven game loop
|   +-- game/           # Game logic (C + ASM)
|       +-- main.c      # Entry point and main game loop
|       +-- player.c    # Player mechanics
|       +-- levels.c    # Level data and management
|       +-- chrono.c    # Time-manipulation mechanics
|       +-- hud.c       # HUD / score display
+-- assets/
|   +-- graphics/       # UDG / sprite data
|   +-- sound/          # Sound effect definitions
+-- build/              # Compiled output (.tap, .tzx, .bin)
+-- tools/
|   +-- z88dk/          # z88dk cross-compiler (auto-installed)
|   +-- pasmo/          # Standalone assembler
|   +-- fuse/           # Fuse ZX Spectrum emulator
+-- docs/               # Design documents
+-- build.bat           # One-click build script
+-- run.bat             # Build + launch in emulator
+-- env.bat             # Environment setup
```

## Quick Start

1. **Set up environment**: Run `env.bat` to configure paths
2. **Build**: Run `build.bat` to compile the game
3. **Run**: Run `run.bat` to build and launch in Fuse emulator

## Controls

- **Q/A** - Up/Down
- **O/P** - Left/Right
- **Space** - Action / Time Shift
- **M** - Pause

## Target Platform

- **ZX Spectrum 48K** (compatible with 128K)
- Screen resolution: 256x192 pixels
- 8 colors x 2 brightness levels
# Heaven-Chrome
