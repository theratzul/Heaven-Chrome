# Chronos - A Time-Bending Adventure

Chronos is a time-manipulation action game where the player can slow, stop, and rewind time to solve puzzles and defeat enemies. Originally built for the **ZX Spectrum 48K**, the repository now also contains a modern, beautifully designed **Web Version** with enhanced graphics while maintaining the same core mechanics.

## How it Works in Detail

The core mechanic of Chronos involves spatial movement coupled with time manipulation. The player navigates a grid-based level containing walls, platforms, and hazards. 

- **Movement:** The player can move in four directions (Up, Down, Left, Right). 
- **Time Shift (Slow):** By pressing and holding `SPACE`, the player taps into their Chrono Energy to slow down time. This causes enemies/hazards and the general game loop to run at a reduced speed, allowing the player to safely navigate past fast-moving obstacles or execute precise maneuvers.
- **Energy Management:** The Time Shift ability drains Chrono Energy while active. When `SPACE` is released, the energy gradually recharges. If energy is depleted, the time slow effect cannot be maintained.
- **Progression:** The player must reach the exit tile of the level to advance, avoiding hazards. Touching a hazard costs one life and resets the player to the starting point.

## Project Structure

```
Chronos/
+-- src/                # ZX Spectrum source code (C and ASM)
|   +-- engine/         # Low-level engine (ASM routines)
|   +-- game/           # Game logic (C + ASM)
+-- web/                # Modern HTML5 Canvas Game (JS/HTML/CSS)
|   +-- index.html      # Main HTML layout
|   +-- style.css       # Neon cyber-style UI and styling
|   +-- script.js       # Game logic, rendering, and levels
+-- assets/             # Graphics and sound assets for ZX version
+-- build/              # Compiled output (.tap, .tzx, .bin)
+-- tools/              # Cross-compilers and emulators
+-- build.bat           # Windows ZX build script
+-- run.bat             # Windows ZX run script
+-- env.bat             # Windows environment setup
+-- build.sh            # Linux ZX build script
+-- run.sh              # Linux ZX run script
+-- env.sh              # Linux environment setup
```

## How to Run

### Windows (ZX Spectrum Version)
1. **Set up environment**: Open a command prompt and run `env.bat` to configure paths.
2. **Build**: Run `build.bat` to compile the game using z88dk.
3. **Run**: Run `run.bat` to launch the compiled game in the Fuse emulator.

### Linux (ZX Spectrum Version)
1. **Set up environment**: Source the environment script in your terminal: `source env.sh`
2. **Build**: Execute `./build.sh` to compile the game.
3. **Run**: Execute `./run.sh` to run the game in your local ZX Spectrum emulator (e.g. Fuse).

### Web Version (Any OS)
1. Navigate to the `web` directory in your file explorer.
2. Open `index.html` in any modern web browser (Chrome, Firefox, Edge, Safari).
3. The game will run locally—no build process or server required! 

## Controls

### Web Version
- **W/A/S/D or Arrow Keys or Q/A/O/P** - Move Up, Left, Down, Right
- **Space** - Action / Time Shift
- **M** - Pause

### ZX Spectrum Version
- **Q/A** - Up/Down
- **O/P** - Left/Right
- **Space** - Action / Time Shift
- **M** - Pause

## Target Platforms

- **ZX Spectrum 48K** (compatible with 128K): 256x192 resolution, 8 colors.
- **Web Browsers**: HTML5 Canvas with modern CSS styling and 60 FPS graphics.
