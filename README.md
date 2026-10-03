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
+-- android/            # Capacitor-based Android Project (F-Droid ready)
+-- java/               # Native Java 2D + Swing Desktop Edition (OpenJDK 21)
+-- linux/              # Native Linux (Debian / Steam) C project (SDL2)
+-- windows/            # Windows 11 (64-bit / Steam) C project (SDL2 + MinGW)
+-- fastlane/           # F-Droid Fastlane metadata (descriptions & icon)
+-- metadata/           # F-Droid build recipe (com.popabogdan.heavenchronos.yml)
+-- .github/workflows/  # CI/CD pipelines (Android, Linux, Windows, Docker, Release)
+-- build-java.sh       # Java compile & executable JAR builder
+-- run-java.sh         # Java desktop launcher
+-- build-windows.sh    # Windows 11 C build & Steam packager script
+-- build-windows.bat   # Windows 11 native build batch script
+-- run-windows.sh      # Windows launcher (Wine on Linux, native on Windows)
+-- run-windows.bat     # Windows 11 native launcher
+-- build.bat / .sh     # ZX build scripts for Windows/Linux
+-- build-android.sh    # Android build script (Release & Debug APKs)
+-- build-linux.sh      # Linux & Steam native C build script
+-- run-linux.sh        # Linux launcher script
+-- run.bat / .sh       # ZX run scripts for Windows/Linux
+-- env.bat / .sh       # Environment setup scripts
+-- tools/              # ADB testing, level editors, compilers, emulators
+-- docs/               # Architecture, cleanup, publishing, and K8s docs
```

## How to Run

### Java Desktop Edition (OpenJDK 21 - Cross-Platform)
1. **Compile**: Run `./build-java.sh` to compile with standard `javac` and generate `java/bin/heaven-chrome.jar`.
2. **Run**: Run `./run-java.sh` or `java -jar java/bin/heaven-chrome.jar`.
3. **Features**: Antialiased Java 2D graphics, pure procedural `javax.sound.sampled` audio synthesizer, full 20 realms, and keyboard controls with zero third-party dependencies.

### Windows 11 & Steam Build
1. **Compile**: Run `./build-windows.sh` (on Linux via MinGW cross-compiler) or `build-windows.bat` / `make -C windows` (on Windows 11).
   - Generates 64-bit Windows executable `windows/bin/heaven-chrome.exe` bundled with `SDL2.dll` and application icon.
2. **Run (Auto-OS Detection)**:
   - On Linux: Run `./run-windows.sh` — automatically detects Linux and starts via Wine.
   - On Windows: Run `run-windows.bat` or `./run-windows.sh` — launches normally.
3. **Add to Steam**:
   - Packaged release zip: `windows/heaven-chrome-windows.zip`.
   - In Steam client: Click **Games** > **Add a Non-Steam Game to My Library...** > Browse and select `heaven-chrome.exe`.

### Linux & Steam Native Version (Debian / Ubuntu / SteamOS / Steam Deck)
1. **Compile**: Run `./build-linux.sh` (or `make -C linux`). Outputs native 64-bit executable `linux/bin/heaven-chrome`.
2. **Run**: Run `./run-linux.sh` (or `./linux/run.sh`).
3. **Steam Upload**: Run `make -C linux package` to produce `linux/heaven-chrome-linux.tar.gz` ready for Steamworks depots.

### Android Version (F-Droid Ready & ADB Testing Without Android Studio)
1. Run `./build-android.sh` to sync web assets and compile signed Release and Debug APKs:
   - Release APK (F-Droid): `android/app/build/outputs/apk/release/Heaven-Chrome.apk`
   - Debug APK: `android/app/build/outputs/apk/debug/Heaven-Chrome.apk`
2. **Test on Device Without Android Studio**:
   - Run `./tools/android-test-adb.sh` to auto-detect connected phone/emulator, install APK, launch, and stream logs.
3. **F-Droid Metadata**: Complete Fastlane metadata is in `fastlane/metadata/android/en-US/` and recipe in `metadata/com.popabogdan.heavenchronos.yml`.

### Windows / Linux (ZX Spectrum Version)
1. **Set up environment**: Run `env.bat` (Windows) or `source env.sh` (Linux).
2. **Build**: Run `build.bat` (Windows) or `./build.sh` (Linux) to compile the game using z88dk.
3. **Run**: Run `run.bat` or `./run.sh` to launch the compiled game in the Fuse emulator (displays title as **HEAVEN CHROME**).

### Web Version (Any OS)
1. Navigate to the `web` directory in your file explorer.
2. Open `index.html` in any modern web browser (Chrome, Firefox, Edge, Safari).
3. The game will run locally—no build process or server required!

### Docker & Kubernetes (Local Cluster & Helm)
1. **Docker**:
   ```bash
   docker build -t heaven-chrome:latest .
   docker run -d -p 8080:80 heaven-chrome:latest
   ```
2. **Kubernetes (Helm)**:
   ```bash
   helm install heaven-chrome ./helm/heaven-chrome --set image.pullPolicy=Never
   ./k8s/port-forward-app.sh
   ```
3. **ArgoCD (GitOps)**:
   - Configured in `k8s/argocd-app.yaml`.
   - Web UI launcher: `./k8s/port-forward-argocd.sh` (https://localhost:8081).
   - Detailed setup in [`docs/DOCKER_AND_KUBERNETES.md`](docs/DOCKER_AND_KUBERNETES.md).

## Publishing & Store Registrations

For complete step-by-step guides on registering and submitting Heaven Chrome to:
* **F-Droid**: Open-source submission & Fastlane metadata
* **Google Play**: Developer console, APK/AAB upload & policies
* **Steam (Windows 11)**: Steamworks depots, executable setup & SteamPipe
* **Steam (Linux & Steam Deck)**: Native Linux depots & gamepad mapping

See the complete guide: [`docs/PUBLISHING_TUTORIAL.md`](docs/PUBLISHING_TUTORIAL.md).

## Controls

### Windows 11 & Linux Steam Versions (Gamepad & Keyboard)
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

- **Windows 11 & Steam**: Native 64-bit Windows executable (`heaven-chrome.exe`) with SDL2 hardware acceleration and embedded icon.
- **Linux & Steam**: Native 64-bit C99 + SDL2 hardware-accelerated app for Debian, Ubuntu, SteamOS, and Steam Deck.
- **Android & F-Droid**: F-Droid ready signed APK (`Heaven-Chrome.apk`) with Fastlane metadata and reproducible build recipe.
- **ZX Spectrum 48K**: 256x192 resolution, 8 colors (z88dk).
- **Web Browsers**: HTML5 Canvas with modern CSS styling, web audio synthesizer, and responsive layout.
- **Docker & Kubernetes**: Nginx-based microservice with Helm chart and ArgoCD GitOps management.
