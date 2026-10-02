# Heaven Chrome - A Divine Time-Bending Adventure

Heaven Chrome is a time-manipulation action game where the player can slow, stop, and rewind time to solve puzzles and defeat enemies. Originally built for the **ZX Spectrum 48K**, the repository now also contains a modern, beautifully designed **Web Version** and an **Android App** with enhanced heavenly graphics while maintaining the same core mechanics.

**Game Purpose:** The purpose of Heaven Chrome is to test your timing and reflexes as you guide an angelic soul through perilous heavenly realms. Your goal is to navigate past demonic hazards and reach the Pearly Gates in order to ascend to higher levels of existence, ultimately achieving eternal peace. You must strategically use your Divine Grace to slow down time when faced with impossible odds.

**Created by: popa bogdan**

## How it Works in Detail

The core mechanic of Heaven Chrome involves spatial movement coupled with time manipulation. The player navigates a grid-based level containing walls (marble blocks), platforms (clouds), and hazards (red crosses). 

- **Movement:** The player (an angelic glowing orb) can move in four directions (Ascend, Descend, Move Left, Move Right). 
- **Divine Time Shift (Slow):** By pressing and holding `SPACE`, the player taps into their Divine Grace to slow down time. This causes enemies/hazards and the general game loop to run at a reduced speed, allowing the player to safely navigate past fast-moving obstacles or execute precise maneuvers.
- **Energy Management:** The Divine Time Shift ability drains Divine Grace while active. When `SPACE` is released, the energy gradually recharges. If energy is depleted, the time slow effect cannot be maintained.
- **Progression:** The player must reach the exit (the Pearly Gates) to advance, avoiding hazards. Touching a hazard costs one Soul (life) and resets the player to the starting point. The score is represented as "Faith Score".

## Project Structure

```
Chronos/
+-- src/                # ZX Spectrum source code (C and ASM)
+-- web/                # Modern HTML5 Canvas Game (JS/HTML/CSS)
+-- android/            # Capacitor-based Android Project
+-- .github/workflows/  # CI/CD pipelines (e.g. android.yml)
+-- assets/             # Graphics and sound assets for ZX version
+-- build/              # Compiled output (.tap, .tzx, .bin)
+-- tools/              # Cross-compilers and emulators
+-- build.bat / .sh     # ZX build scripts for Windows/Linux
+-- run.bat / .sh       # ZX run scripts for Windows/Linux
+-- env.bat / .sh       # Environment setup scripts
```

## How to Run

### Windows / Linux (ZX Spectrum Version)
1. **Set up environment**: Run `env.bat` (Windows) or `source env.sh` (Linux).
2. **Build**: Run `build.bat` (Windows) or `./build.sh` (Linux) to compile the game using z88dk.
3. **Run**: Run `run.bat` or `./run.sh` to launch the compiled game in the Fuse emulator.

### Web Version (Any OS)
1. Navigate to the `web` directory in your file explorer.
2. Open `index.html` in any modern web browser (Chrome, Firefox, Edge, Safari).
3. The game will run locally—no build process or server required! 

### Android Version
1. Ensure you have Node.js and Java JDK installed.
2. Run `npm install` and `npx cap sync android`.
3. To build locally, run `cd android && ./gradlew assembleDebug`. The generated APK will be in `android/app/build/outputs/apk/debug/app-debug.apk`.
4. Alternatively, use the **GitHub Actions** workflow included in the repo which automatically builds the APK on every push to main.

## Controls

### Web / Android Version
- **W/A/S/D or Arrow Keys or Q/A/O/P** - Ascend, Move Left, Descend, Move Right
- **Space** - Divine Time Shift (Slow)
- **M** - Pause (Contemplation)

### ZX Spectrum Version
- **Q/A** - Up/Down
- **O/P** - Left/Right
- **Space** - Action / Time Shift
- **M** - Pause

## Target Platforms

- **ZX Spectrum 48K**: 256x192 resolution, 8 colors.
- **Web Browsers**: HTML5 Canvas with modern CSS styling and heavenly graphics.
- **Android**: Wrapped Web Version using Capacitor.
