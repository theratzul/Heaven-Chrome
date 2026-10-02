# Heaven Chrome - A Divine Time-Bending Adventure

Heaven Chrome is a time-manipulation action game where the player can slow, stop, and rewind time to solve puzzles and defeat enemies. Originally built for the **ZX Spectrum 48K**, the repository now also contains a modern, beautifully designed **Web Version** and an **Android App** with enhanced heavenly graphics while maintaining the same core mechanics.

**Game Purpose:** The purpose of Heaven Chrome is to test your timing and reflexes as you guide an angelic soul through perilous heavenly realms. Your goal is to navigate past demonic hazards and reach the Pearly Gates in order to ascend to higher levels of existence, ultimately achieving eternal peace. You must strategically use your Divine Grace to slow down time when faced with impossible odds.

**Created by: popa bogdan**

## How it Works in Detail

The core mechanic of Heaven Chrome involves spatial movement coupled with time manipulation. The player navigates a grid-based level containing walls (marble blocks), platforms (clouds), and hazards (red crosses). 

- **Movement:** The player (an angelic glowing orb) can move in four directions (Ascend, Descend, Move Left, Move Right). 
- **Divine Time Shift (Slow):** By pressing and holding `SPACE` (or the on-screen gold button), the player taps into their Divine Grace to slow down time. This causes hazards and the game loop to run in slow motion, accompanied by pitch/tempo warping audio.
- **Energy Management:** The Divine Time Shift ability drains Divine Grace while active. When released, energy gradually recharges.
- **Guardian Angels:** Every one of the 20 heavenly realms contains a Guardian Angel. Collecting an angel bestows holy blessing, granting **+500 Faith Score** and ringing heavenly chimes.
- **Progression Across 20 Realms:** The player must ascend through 20 handcrafted heavenly realms by reaching the Pearly Gates in each realm.
- **Celestial MIDI Music:** A polyphonic synthesizer plays an ethereal hymn background soundtrack in real-time, slowing and downshifting harmonically during Divine Time Shift. On ZX Spectrum 48K, a 1-bit beeper music engine plays the divine hymn on title and victory screens.

## Project Structure

```
Heaven-Chrome/
+-- src/                # ZX Spectrum source code (C and ASM)
+-- web/                # Modern HTML5 Canvas Game (JS/HTML/CSS)
+-- android/            # Capacitor-based Android Project
+-- linux/              # Native Linux (Debian / Steam) C project (SDL2)
+-- .github/workflows/  # CI/CD pipelines (Android & Linux Steam)
+-- build.bat / .sh     # ZX build scripts for Windows/Linux
+-- build-android.sh    # Android build script
+-- build-linux.sh      # Linux & Steam native C build script
+-- run-linux.sh        # Linux launcher script
+-- run.bat / .sh       # ZX run scripts for Windows/Linux
+-- env.bat / .sh       # Environment setup scripts
+-- tools/              # Level editors, compilers, emulators
```

## How to Run

### Linux & Steam Native Version (Debian / Ubuntu / SteamOS / Steam Deck)
1. **Compile**: Run `./build-linux.sh` (or `make -C linux`). Outputs native 64-bit executable `linux/bin/heaven-chrome`.
2. **Run**: Run `./run-linux.sh` (or `./linux/run.sh`).
3. **Steam Upload**: Run `make -C linux package` to produce `linux/heaven-chrome-linux.tar.gz` ready for Steamworks depots.

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
2. Run `./build-android.sh` to sync web assets and compile `Heaven-Chrome.apk` into `android/app/build/outputs/apk/debug/Heaven-Chrome.apk`.
3. Alternatively, download the APK built automatically by **GitHub Actions** on every push to main.

## Controls

### Linux & Steam Version (Debian / Steam Deck / Gamepad)
- **D-Pad / Left Stick or WASD / Arrows** - Ascend, Descend, Move Left, Move Right
- **Button [A] / Right Trigger or SPACE** - Hold for Divine Time Shift (Slow Motion)
- **Button [Start] / [Back] or P / ESC** - Pause / Contemplate
- **Button [Y] or M** - Toggle Celestial Audio Mute
- **F11 or Alt+Enter** - Toggle Fullscreen

### Android Version (Touch Screen)
- **On-Screen D-Pad (▲ / ▼ / ◀ / ▶)** - Ascend, Descend, Move Left, Move Right
- **Slow Time Button (Hold)** - Divine Time Shift (Slow Motion)
- **Pause Button (⏸)** - Pause / Contemplate
- **Sound Button (🔊/🔇)** - Toggle Heavenly MIDI Music & SFX
- **Tap Screen** - Start Game / Resurrect / Resume

### Web / Desktop Version
- **W/A/S/D or Arrow Keys or Q/A/O/P** - Ascend, Move Left, Descend, Move Right
- **Space** - Divine Time Shift (Slow)
- **M** - Pause (Contemplation)
- **Audio Icon (🔊/🔇)** - Toggle Celestial Soundtrack

### ZX Spectrum Version
- **Q/A** - Up/Down
- **O/P** - Left/Right
- **Space** - Action / Time Shift
- **M** - Pause

## Target Platforms

- **Linux & Steam**: Native 64-bit C99 + SDL2 hardware-accelerated app for Debian, Ubuntu, SteamOS, and Steam Deck.
- **ZX Spectrum 48K**: 256x192 resolution, 8 colors (z88dk).
- **Web Browsers**: HTML5 Canvas with modern CSS styling, web audio synthesizer, and responsive layout.
- **Android**: Wrapped Web Version using Capacitor (`Heaven-Chrome.apk`).
