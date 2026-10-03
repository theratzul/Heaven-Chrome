# Heaven Chrome — Installation & Setup Guide

> A complete guide to setting up your development environment and running Heaven Chrome on every supported platform: **ZX Spectrum 48K**, **Web**, and **Android**.

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Platform A — ZX Spectrum 48K (z88dk + Fuse)](#2-platform-a--zx-spectrum-48k-z88dk--fuse)
3. [Platform B — Web Browser](#3-platform-b--web-browser)
4. [Platform C — Android (Node.js + Capacitor)](#4-platform-c--android-nodejs--capacitor)
   - 4.1 [Tool Explanations](#41-tool-explanations)
   - 4.2 [Windows Setup](#42-windows-setup)
   - 4.3 [Linux / macOS Setup](#43-linux--macos-setup)
   - 4.4 [Debug vs Release APK](#44-debug-vs-release-apk)
   - 4.5 [Testing Android APK without Android Studio](#45-testing-android-apk-without-android-studio)
   - 4.6 [Mobile Screen Formatting & Touch Controls (Samsung S24)](#46-mobile-screen-formatting--touch-controls-samsung-s24)
   - 4.7 [20 Realms Level Architecture & RLE Compression](#47-20-realms-level-architecture--rle-compression)
5. [CI/CD — GitHub Actions](#5-cicd--github-actions)
6. [Repository Scripts Reference](#6-repository-scripts-reference)
7. [Troubleshooting](#7-troubleshooting)

---

## 1. Project Overview

Heaven Chrome targets three distinct platforms, each requiring a different toolchain:

| Platform | Technology | Output |
|---|---|---|
| ZX Spectrum 48K | C + Z80 ASM compiled by z88dk | `.tap` tape image, run in Fuse emulator |
| Web Browser | HTML5 Canvas + JavaScript + CSS | Open `web/index.html` directly in any browser |
| Android | Web app wrapped via Capacitor | `.apk` installable on any Android device |

---

## 2. Platform A — ZX Spectrum 48K (z88dk + Fuse)

The ZX Spectrum version is the **original** version of Heaven Chrome. Source code lives in `src/` and is split between **C** (game logic: `main.c`, `player.c`, `levels.c`, `chrono.c`, `hud.c`) and **Z80 Assembly** (engine layer: `sprites.asm`, `video.asm`, `input.asm`, `sound.asm`, `isr.asm`).

### 2.1 Tool Explanations

#### z88dk — The Z80 C/Assembly Cross-Compiler Toolchain
**Bundled location:** `tools/z88dk/`

z88dk is a full C and Z80 assembly development kit for 8-bit Z80 computers. It includes the following components used by this project:

| Component | Role |
|---|---|
| `zcc` | The compiler driver — orchestrates the full pipeline: C → assembly → linking → tape image |
| `ZCCCFG` env var | Points to `lib/config/` — z88dk reads platform definitions from here |
| `Z80_OZFILES` env var | Points to `lib/clibs/` — precompiled C library objects for linking |
| `z88dk/bin/` | Contains `zcc`, `z80asm`, `appmake`, and other tools — must be on `PATH` |

**Key `zcc` flags used in `build.bat`:**

| Flag | Meaning |
|---|---|
| `+zx` | Target platform: ZX Spectrum |
| `-startup=1` | Use ROM BASIC startup (generates a BASIC loader on the tape) |
| `-clib=sdcc_iy` | Use the SDCC-compatible C library with IY register used as frame pointer |
| `-SO3` | Optimization level 3 (maximum) |
| `--max-allocs-per-node200000` | Allows the optimizer more iterations for better code generation |
| `--opt-code-speed` | Favor execution speed over code size |
| `-pragma-define:CRT_ORG_CODE=0x8000` | Place compiled code at memory address 32768 (above the BASIC area) |
| `-pragma-define:REGISTER_SP=0xD000` | Set stack pointer to 0xD000 (53248), safely above the game code |
| `-pragma-define:CRT_STACK_SIZE=512` | Reserve 512 bytes for the call stack |
| `-create-app` | Post-link: package everything into a `.tap` / `.tzx` tape image |
| `-o build/chronos` | Output base name (`build/chronos.tap` is created) |

#### Fuse — The ZX Spectrum Emulator
**Bundled location:** `tools/fuse/`

Fuse (Free Unix Spectrum Emulator) is the most accurate open-source ZX Spectrum emulator. It cycle-accurately emulates:

- The **Zilog Z80 CPU** including all undocumented opcodes
- The **ULA** (Uncommitted Logic Array) — handles video timing, border effects, keyboard matrix scanning, and the tape interface
- The **beeper** (single-channel audio on 48K)
- Tape loading via the virtual tape interface

**Flags used when launching:**

| Flag | Meaning |
|---|---|
| `--machine 48` | Emulate the 48K Spectrum (16KB ROM + 48KB RAM, no AY sound chip) |
| `--tape build/chronos.tap` | Load and auto-play the tape image (auto-runs the BASIC loader) |

---

### 2.2 Windows Setup

**Requirements:** Windows 10+, no additional installs (tools are bundled).

```bat
REM Step 1: Open the project folder in a terminal (cmd or PowerShell)
cd C:\path\to\Heaven-Chronos

REM Step 2: Set up environment (sets PATH, ZCCCFG, Z80_OZFILES)
env.bat

REM Step 3: Build — compiles all C and ASM sources into build\chronos.tap
build.bat

REM Step 4: Run — launches the compiled game in Fuse
run.bat
```

---

### 2.3 Linux Setup

On Linux, `build.sh` and `run.sh` delegate to the Windows `.bat` files through **Wine**.

#### Option A — Wine (uses the bundled Windows tools, easiest)

```bash
# Install Wine
sudo apt install wine          # Ubuntu/Debian
sudo dnf install wine          # Fedora
sudo pacman -S wine            # Arch

# Set up, build, and run
source env.sh
./build.sh
./run.sh
```

`run.sh` automatically finds Fuse in this priority order:
1. System-installed `fuse` binary
2. `tools/fuse/fuse` (native Linux build, if present)
3. `tools/fuse/fuse.exe` via Wine (fallback)

#### Option B — Native Linux tools

**Install z88dk from source:**
```bash
sudo apt install git make gcc libboost-dev texinfo bison flex libxml2-dev
git clone --recursive https://github.com/z88dk/z88dk.git && cd z88dk
chmod +x build.sh && ./build.sh

# Export env vars (add to ~/.bashrc to persist)
export Z88DK=$HOME/z88dk
export ZCCCFG=$Z88DK/lib/config
export Z80_OZFILES=$Z88DK/lib/clibs
export PATH=$Z88DK/bin:$PATH
```

**Install Fuse:**
```bash
sudo apt install fuse-emulator-gtk    # Ubuntu/Debian
sudo pacman -S fuse-emulator          # Arch
sudo dnf install fuse-emulator        # Fedora
```

**Build and run manually:**
```bash
zcc +zx -vn -startup=1 -clib=sdcc_iy -SO3 \
    --max-allocs-per-node200000 --opt-code-speed \
    -pragma-define:CRT_ORG_CODE=0x8000 \
    -pragma-define:REGISTER_SP=0xD000 \
    -pragma-define:CRT_STACK_SIZE=512 \
    src/game/main.c src/game/player.c src/game/levels.c \
    src/game/chrono.c src/game/hud.c \
    src/engine/sprites.asm src/engine/video.asm \
    src/engine/input.asm src/engine/sound.asm src/engine/isr.asm \
    -o build/chronos -create-app

fuse --machine 48 --tape build/chronos.tap
```

---

## 3. Platform B — Web Browser

The Web version requires **no installation whatsoever** — it is a completely self-contained HTML5 application.

### What the Web Version Is

`web/index.html` contains a full Heaven Chrome port using the **HTML5 Canvas API**. The game loop, collision detection, time-shift mechanic, and all rendering are implemented in JavaScript. It is also the source that gets embedded into the Android APK by Capacitor.

### Running

1. Navigate to the `web/` folder.
2. Open `index.html` in any modern browser — double-click it in your file manager.
3. No server or build step needed.

### Browser Compatibility

| Browser | Version | Support |
|---|---|---|
| Chrome / Chromium | 90+ | Full |
| Firefox | 88+ | Full |
| Edge | 90+ | Full |
| Safari | 14+ | Full |
| Internet Explorer | Any | Not supported |

---

## 4. Platform C — Android (Node.js + Capacitor)

The Android version wraps `web/` in a native Android WebView shell using **Capacitor**. The game itself is unchanged — Capacitor provides the packaging, native container, and APK build pipeline.

### 4.1 Tool Explanations

#### Node.js (version >= 20.0.0 LTS required)

Node.js is the JavaScript runtime that powers the Capacitor CLI tooling. It is used **only during the build phase**, not inside the final Android app.

| Component | Role |
|---|---|
| `node` | JavaScript runtime (must be v20+) |
| `npm` | Package manager — `npm install` downloads `@capacitor/cli`, `@capacitor/core`, `@capacitor/android` into `node_modules/` |
| `npx` | Runs local binaries — `npx cap` runs `node_modules/.bin/cap` without a global install |

> **Why v20 minimum?** `@capacitor/cli ^7.x` uses Node.js APIs that were stabilized in v20 (notably the native `fetch` global and updated `vm` module). Node 18 and below trigger the `[fatal] The Capacitor CLI requires NodeJS >=20.0.0` error.

#### Capacitor CLI (`@capacitor/cli ^7.6.9`)

Capacitor is Ionic's open-source bridge between web apps and native mobile platforms. The key commands:

| Command | What it does |
|---|---|
| `npx cap sync android` | Reads `capacitor.config.json`, copies `web/` into `android/app/src/main/assets/public/`, updates native plugin configs |
| `npx cap open android` | Opens the `android/` project in Android Studio |
| `npx cap add android` | (First time only) Scaffolds the `android/` native project |

**`capacitor.config.json` fields:**

```json
{
  "appId": "com.popabogdan.heavenchronos",
  "appName": "Heaven Chrome",
  "webDir": "web"
}
```

| Field | Meaning |
|---|---|
| `appId` | Reverse-domain app identifier — Android uses this as the unique package name on the device and Play Store |
| `appName` | Human-readable name shown on the device launcher |
| `webDir` | The local folder Capacitor copies into the Android APK's WebView assets |

#### Gradle & Android SDK

`android/` is a standard Android Gradle project. The Gradle wrapper (`gradlew`) downloads the correct Gradle version automatically. What you need installed:

| Requirement | Why |
|---|---|
| Java JDK 21 | Gradle runs on the JVM; JDK 21 matches the CI configuration |
| Android SDK | Provides `android.jar` (compilation) and `build-tools` (packaging + signing) |
| `ANDROID_HOME` env var | Tells Gradle where to find the SDK |

---

### 4.2 Windows Setup

#### Step 1 — Install Node.js 20 LTS
1. Download the Windows LTS installer from [https://nodejs.org](https://nodejs.org).
2. Run it — ensure **"Add to PATH"** is ticked.
3. Verify: `node --version` (must be `v20.x.x` or higher).

#### Step 2 — Install Java JDK 21
1. Download Temurin JDK 21 from [https://adoptium.net](https://adoptium.net).
2. Run the installer — it sets `JAVA_HOME` automatically.
3. Verify: `java --version`.

#### Step 3 — Install Android SDK
**Via Android Studio (recommended):**
1. Download from [https://developer.android.com/studio](https://developer.android.com/studio).
2. Open **SDK Manager** and install **Android SDK Platform 34** and **Build-Tools 34.x**.

**Set environment variable:**
```bat
setx ANDROID_HOME "C:\Users\YourName\AppData\Local\Android\Sdk"
setx PATH "%PATH%;%ANDROID_HOME%\platform-tools"
```

#### Step 4 — Build
```bat
npm install
npx cap sync android
cd android
gradlew.bat assembleDebug
```

APK location: `android\app\build\outputs\apk\debug\Heaven-Chrome.apk`

---

### 4.3 Linux / macOS Setup

#### Step 1 — Install Node.js 20 LTS

**Using nvm (recommended):**
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.bashrc    # or ~/.zshrc
nvm install 20
nvm use 20
node --version      # v20.x.x
```

**Using package manager:**
```bash
# Ubuntu / Debian
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# Arch Linux
sudo pacman -S nodejs npm

# macOS
brew install node@20
```

#### Step 2 — Install Java JDK 21
```bash
sudo apt install openjdk-21-jdk      # Ubuntu/Debian
sudo pacman -S jdk21-openjdk         # Arch
brew install openjdk@21              # macOS
java --version
```

#### Step 3 — Install Android SDK

**Via Android Studio:**
Download from [https://developer.android.com/studio](https://developer.android.com/studio), then:
```bash
# Add to ~/.bashrc or ~/.zshrc
export ANDROID_HOME=$HOME/Android/Sdk          # Linux
export ANDROID_HOME=$HOME/Library/Android/sdk  # macOS
export PATH=$PATH:$ANDROID_HOME/platform-tools
```

**Via command-line tools only (Linux):**
```bash
mkdir -p ~/Android/cmdline-tools/latest
# Download commandlinetools-linux-*.zip from developer.android.com/studio#command-line-tools-only
unzip commandlinetools-linux-*.zip -d ~/Android/cmdline-tools/latest/
yes | ~/Android/cmdline-tools/latest/bin/sdkmanager --licenses
~/Android/cmdline-tools/latest/bin/sdkmanager \
    "platform-tools" "platforms;android-34" "build-tools;34.0.0"

export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools
```

#### Step 4 — Build
```bash
npm install
npx cap sync android
cd android && chmod +x gradlew
./gradlew assembleDebug
```

APK location: `android/app/build/outputs/apk/debug/Heaven-Chrome.apk`

**Install to a connected device:**
```bash
adb install android/app/build/outputs/apk/debug/Heaven-Chrome.apk
```

---

### 4.4 Debug vs Release APK

| Type | Gradle command | Signing | Use case |
|---|---|---|---|
| Debug | `./gradlew assembleDebug` | Auto-signed with debug keystore | Sideloading, testing |
| Release | `./gradlew assembleRelease` | Requires your own keystore | Play Store distribution |

---

### 4.5 Testing Android APK without Android Studio

You do **not** need Android Studio installed to test and debug the generated APK. Here are the 4 recommended testing approaches:

#### Method 1 — Direct Hardware Testing on Phone (One-Click `./install-phone.sh`)
This provides the most accurate performance and real touchscreen evaluation.

1. **Enable Developer Options & USB Debugging on your phone:**
   - Go to **Settings** → **About phone** → **Software information**.
   - Tap **Build number** 7 times until you see *"Developer mode has been enabled"*.
   - Return to **Settings** → **Developer options** → toggle **USB debugging** to **ON**.
2. **Connect phone to computer via USB cable:**
   - **VirtualBox USB Passthrough:** Because this Linux environment runs in VirtualBox, click the VirtualBox window top menu: **Devices** → **USB** → check the box next to your phone (e.g. `SAMSUNG Electronics...` or `SM-S921...`).
   - Unlock your phone and accept the prompt: *"Allow USB debugging?"* (select *Always allow*).
3. **One-click installation and launch:**
   ```bash
   ./install-phone.sh
   ```
   *This automatically detects your phone via ADB, installs `Heaven-Chrome.apk`, and launches the game on your screen!*
4. *(Alternative)* **Wireless ADB (Same Wi-Fi):**
   - On phone: **Settings** → **Developer options** → toggle **Wireless debugging** to **ON**.
   - Note the IP & Port shown (e.g. `192.168.1.50:38521`).
   - Run: `./install-phone.sh 192.168.1.50:38521`.
5. *(Alternative)* **Direct Browser Download via Flask Server:**
   - Start the local Flask server: `./run-flask.sh`.
   - On your phone browser, open `http://<computer-ip>:5000/download` to download and install directly!

#### Method 2 — Command-Line Android Emulator (No Android Studio GUI)
You can run the official Google Android Emulator completely headless or in a lightweight window using the command-line tools:

1. **Install the emulator binary and an Android system image:**
   ```bash
   export PATH="$PATH:$HOME/android-sdk/cmdline-tools/latest/bin:$HOME/android-sdk/platform-tools"
   sdkmanager "emulator" "system-images;android-34;google_apis;x86_64"
   ```
2. **Create an Android Virtual Device (AVD):**
   ```bash
   avdmanager create avd -n S24_Test -k "system-images;android-34;google_apis;x86_64" --device "pixel_8"
   ```
3. **Launch the emulator:**
   ```bash
   $HOME/android-sdk/emulator/emulator -avd S24_Test &
   ```
4. **Deploy the APK once the virtual device boots:**
   ```bash
   adb install -r android/app/build/outputs/apk/debug/Heaven-Chrome.apk
   ```

#### Method 3 — Mobile Browser Simulation with Touch Emulation (Instant Iteration)
Because Capacitor apps wrap `web/` inside an Android WebView, you can test the game layout and touch controls instantly in your browser:

1. **Start a local static server:**
   ```bash
   python3 -m http.server 8080 --directory web
   ```
2. **Open your browser (Firefox / Chrome / Chromium):**
   ```bash
   firefox http://localhost:8080 &
   ```
3. **Enable Responsive Mobile Device Mode:**
   - Press <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>M</kbd>.
   - Set viewport dimensions to Samsung Galaxy S24 resolution: **`412 × 915`** (or **`384 × 832`**).
   - Ensure the **Touch Simulation** icon (hand/finger) is enabled.
   - Test the virtual D-Pad, Slow Time button, pause, and start buttons with your mouse simulating touch events.

#### Method 4 — Download via GitHub Actions Artifacts
Push any commit to your repository, wait ~1 minute for GitHub Actions to build `Heaven-Chrome.apk`, open GitHub on your phone browser, download the artifact from the latest run, and install it directly on your device.

---

### 4.6 Mobile Screen Formatting & Touch Controls (Samsung S24)

The application has been engineered to deliver an ergonomic handheld console experience on smartphones (such as Samsung Galaxy S24) with tall 19.5:9 / 20:9 aspect ratios:

* **Responsive 4:3 Scaling:** The 800×600 pixel internal canvas is scaled dynamically (`aspect-ratio: 4 / 3; width: 100%; max-height: 50vh;`) with safe-area padding (`env(safe-area-inset-top)` / `env(safe-area-inset-bottom)`). This eliminates horizontal cropping and ensures the entire game world is 100% visible in portrait mode.
* **Samsung S24 Typography & Anti-Font-Boosting:**
  * Enabled `-webkit-text-size-adjust: 100%; text-size-adjust: 100%;` to prevent Samsung Internet and Android WebView from automatically auto-inflating and distorting font sizes (Text Autosizer bug).
  * Re-engineered the title `h1#titleText` with safe fluid clamping (`clamp(15px, 4.6vw, 22px)` on mobile) and `white-space: nowrap` so "HEAVEN CHROME" never clips or wraps.
  * Formatted subtitle (`#subText`) on a single elegant line without awkward line breaks or hyphenation.
  * Redesigned the controls panel into a sleek, compact summary (`🕹️ MOVE`, `⏳ SLOW`, `⏸️ PAUSE`) with zero vertical overflow.
  * Dedicated portrait media query `@media (max-width: 480px) and (orientation: portrait)` tailored to Samsung Galaxy S24 screen proportions (412×915 and 384×854).
* **Ergonomic Control Deck:** In portrait mode, the lower half of the phone screen hosts a dedicated, non-intrusive celestial controller deck so fingers never obstruct the game view.
* **Virtual D-Pad (Left Thumb):** 4-way direction pad (▲, ▼, ◀, ▶) featuring smooth touch sliding (`touchmove` tracking) so players can glide between directions without lifting their thumb.
* **Divine Slow Time Button (Right Thumb):** Large, pulsing golden button that triggers and sustains the Divine Grace time-slow mechanic while held. The clepsidra (hourglass ⏳) and typography have been scaled with flex containment (`overflow: hidden`) to guarantee it never clips or exits the circle on Android devices.
* **Pause & Start Interactions:** Quick-access pause buttons (⏸) on both the control deck and the HUD, plus full-screen tap-to-start / tap-to-resurrect support.

---

### 4.7 20 Realms Level Architecture & RLE Compression

The game features **20 distinct, progressive heavenly realms** across both the Web/Android and ZX Spectrum versions:

* **Z80 Memory Constraints & RLE Solution:**
  * Raw uncompressed 32×24 level maps would consume `20 × 768 = 15,360 bytes` (15 KB), threatening the 48K RAM limits above address `0x8000`.
  * Implemented an ultra-compact Run-Length Encoding (RLE) format in [`src/game/levels.c`](src/game/levels.c). All 20 levels compress down to only **4.5 KB** of ROM.
  * At runtime, `level_load(level_num)` instantly decompresses the active level into a single 768-byte screen buffer with zero frame-rate penalty.
* **Level Progression:** Both platforms track ascension through all 20 realms, with the web/mobile HUD displaying real-time progress (`HEAVEN: X/20`).
* **Level Tooling:**
  * [`tools/build_levels.py`](tools/build_levels.py) — Defines and validates all 20 level grids.
---

### 4.8 Heavenly MIDI Music & Guardian Angels System

Both the ZX Spectrum and Web/Android versions include rich atmospheric background music and divine collectibles:

#### 1. Celestial MIDI Soundtrack (Web & Android)
* **Web Audio API Polyphonic Synthesizer (`HeavenMidiSynth`):**
  * Built using pure Web Audio API oscillator nodes (no heavy external sound banks required).
  * 3 simultaneous polyphonic channels:
    * **Lead Divine Hymn:** Triangle wave voice with gentle attack, resonant low-pass filter, and celestial sustain.
    * **Heavenly Harp Arpeggios:** Sine wave rapid arpeggiator creating ethereal shimmering patterns.
    * **Cathedral Organ Bass:** Dual detuned saw/triangle pedal tones giving majestic harmonic depth.
* **Dynamic Time-Shift Audio Warping:**
  * When the player holds `SPACE` or the on-screen **SLOW TIME** button, the music dynamically transitions into slow-motion.
  * The tempo decelerates to 40% speed and pitch down-shifts smoothly via Web Audio time constants (`exponentialRampToValueAtTime`), audibly warping the music during Divine Time Shift.
* **Audio Controls & Chimes:**
  * Volume/mute toggle button (🔊 / 🔇) accessible both on the HUD and the mobile control deck.
  * Audio is initialized on first user interaction (click, keypress, or touch) adhering to modern browser autoplay policies.
  * High-frequency holy chimes play upon collecting Guardian Angels.

#### 2. 1-Bit Beeper Music Engine (ZX Spectrum 48K)
* **Assembly Melody Routine ([`src/engine/sound.asm`](src/engine/sound.asm)):**
  * Handcrafted `_sound_play_music` routine driving the ZX Spectrum 1-bit beeper through port `0xFE` (port 254).
  * Plays the sacred hymn on the title screen and upon clearing each of the 20 heavenly realms.
  * Calibrated pitch table (`_note_table`) maps semitones to Z80 delay cycle counts for accurate pitch reproduction on 3.5 MHz Z80 hardware.

#### 3. Guardian Angels in all 20 Heavenly Realms
* **Guardian Angels (`TILE_ANGEL = 5`):**
  * Distributed across all 20 levels in both versions.
  * **Web/Android:** Rendered with glowing golden halos, fluttering angelic wings, hovering float animation, and radiant light particle emissions. Collecting an angel awards +500 Faith Score and holy chime audio.
  * **ZX Spectrum:** Rendered using an 8×8 custom pixel sprite glyph (`tile_angel_gfx`) rendered with bright cyan on dark blue attributes (`BRIGHT 1 | INK 5 | PAPER 1`). Collecting an angel increases Faith Score by 500 and plays a high-pitched celebratory tone.

---

## 5. Platform D — Linux & Steam (Native C + SDL2)

The Linux version is a high-performance native 64-bit C application engineered specifically for **Debian, Ubuntu, SteamOS, and Steam Deck**.

### 5.1 Architecture & Steam Compatibility
* **Language & Graphics**: Written in standard C99 using **SDL2** with hardware-accelerated rendering (`SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC`).
* **Steam Deck Verified Ready**:
  * Automatically detects game controllers (`SDL_GameController`) including Steam Deck built-in controls, Xbox, and PlayStation pads.
  * Native 800×600 logical resolution with automatic letterboxing/pillarboxing (`SDL_RenderSetLogicalSize`) to fit standard 16:9, 16:10 (Steam Deck 1280×800), or ultrawide monitors.
  * Fullscreen toggle on <kbd>F11</kbd> or <kbd>Alt</kbd>+<kbd>Enter</kbd>.
* **Built-in Audio Synthesizer**: Pure C 3-channel polyphonic synthesizer rendering real-time celestial hymn music, slow-motion pitch warping, and holy chimes via SDL2 audio callback (no external soundfont dependencies).
* **Self-Contained Build**: Development headers are bundled in [`linux/include/SDL2/`](linux/include/SDL2/), meaning the game can be compiled on Debian with only `gcc` and `make` against the pre-installed `libsdl2-2.0-0` runtime.

### 5.2 Build Instructions (Debian / Ubuntu / SteamOS)

1. **Install build tools (if not already installed):**
   ```bash
   sudo apt update
   sudo apt install -y gcc make libsdl2-dev
   ```
   *(Note: If `libsdl2-dev` cannot be installed with sudo, the build system automatically falls back to bundled headers and the system's `libsdl2-2.0.so.0`!)*

2. **Compile the native Linux executable:**
   ```bash
   ./build-linux.sh
   ```
   *Output binary:* [`linux/bin/heaven-chrome`](linux/bin/heaven-chrome) (approx. 52 KB).

3. **Run and test locally:**
   ```bash
   ./run-linux.sh
   # or directly:
   ./linux/run.sh
   ```

### 5.3 Steamworks Packaging & Upload

The Linux build is pre-configured with everything needed to upload to Steam:

1. **Steam App ID (`linux/steam_appid.txt`):**
   * Configured by default to `480` (Valve's Spacewar development App ID for local testing).
   * Once you have registered your game on Steamworks, replace `480` in `linux/steam_appid.txt` with your assigned App ID.

2. **Create the Steam Release Tarball:**
   ```bash
   make -C linux package
   ```
   This generates `linux/heaven-chrome-linux.tar.gz` containing:
   * `heaven-chrome` (64-bit ELF binary)
   * `run.sh` (Steam launcher script setting `LD_LIBRARY_PATH`)
   * `steam_appid.txt` (Steam App ID configuration)
   * `heaven-chrome.desktop` (XDG desktop entry)

3. **Uploading via SteamPipe (ContentBuilder):**
   * Place the contents of `linux/steam_package/` into your SteamPipe depot directory (e.g. `content/linux_depot/`).
   * In your Steamworks depot build script (`depot_build_*.vdf`):
     * Set `FileMapping` to include `*`.
   * In your Steamworks App configuration under **Installation** → **General Installation**:
     * **Operating System**: Linux + SteamOS.
     * **Executable**: `run.sh` (or `heaven-chrome`).

---

## 6. CI/CD — GitHub Actions

### Workflows
* **Android Build:** [`.github/workflows/android.yml`](.github/workflows/android.yml) — Builds and uploads `Heaven-Chrome.apk` on every push.
* **Linux Steam Build:** [`.github/workflows/linux.yml`](.github/workflows/linux.yml) — Builds and uploads `heaven-chrome` and `heaven-chrome-linux.tar.gz` on every push.

---

## 7. Repository Scripts Reference

| Script / Binary | OS | What it does |
|---|---|---|
| [`bin/istioctl`](bin/istioctl) | Linux x86_64 | Istio 1.31.1 CLI for mesh installation, debugging (`analyze`, `proxy-status`). |
| [`bin/argocd`](bin/argocd) | Linux x86_64 | ArgoCD v3.5.3 CLI for GitOps cluster login, sync, and application management. |
| [`bin/kpt`](bin/kpt) | Linux x86_64 | KPT CLI (v1.0.0-beta.61) for packaging and rendering declarative Kubernetes blueprints. |
| [`bin/yq`](bin/yq) | Linux x86_64 | YAML command-line processor (v4.54.1). |
| [`bin/jq`](bin/jq) | Linux x86_64 | JSON command-line processor (v1.7). |
| [`run-perl.sh`](run-perl.sh) | Cross-platform | Boots standalone Perl web server (port 5050) serving web game and APK download. |
| [`run-flask.sh`](run-flask.sh) | Cross-platform | Boots local Flask server serving the web game and direct wireless APK download (`/download`). |
| [`build-linux.sh`](build-linux.sh) | Linux / Debian | One-click script: builds native 64-bit ELF binary `linux/bin/heaven-chrome` with SDL2. |
| [`install-phone.sh`](install-phone.sh) | Linux / macOS | One-click script: detects phone via ADB (cable or wireless), installs APK, and launches game. |
| [`run-linux.sh`](run-linux.sh) | Linux / Debian | Launches native Linux game (delegates to `linux/run.sh`). |
| [`build-android.sh`](build-android.sh) | Linux / macOS | One-click script: syncs `web/` assets into Capacitor and builds `Heaven-Chrome.apk`. |
| [`env.bat`](env.bat) | Windows | Adds `tools\z88dk\bin` to `PATH`; sets `ZCCCFG` and `Z80_OZFILES`. Must be called before building. |
| [`env.sh`](env.sh) | Linux | Delegates to `env.bat` via `wine cmd /c env.bat`. |
| [`build.bat`](build.bat) | Windows | Calls `env.bat`, then runs `zcc` with all source files. Outputs `build\chronos.tap`. |
| [`build.sh`](build.sh) | Linux | Delegates to `build.bat` via `wine cmd /c build.bat`. Outputs `build/chronos.tap`. |
| [`run.bat`](run.bat) | Windows | Calls `build.bat`, then launches Fuse with `--machine 48 --tape build\chronos.tap`. |
| [`run.sh`](run.sh) | Linux | Calls `build.sh`, then launches Fuse (system Fuse → `tools/fuse/fuse` → Wine Fuse fallback). |
| [`tools/build_levels.py`](tools/build_levels.py) | Cross-platform | Validates and generates all 20 levels in JSON and verifies constraints. |
| [`tools/export_levels.py`](tools/export_levels.py) | Cross-platform | Compresses 20 levels via RLE and updates `src/game/levels.c` and `web/script.js`. |

---

## 8. Docker, Kubernetes, Istio & ArgoCD

For complete setup instructions, see the dedicated [KUBERNETES_ISTIO_ARGO_LVM.md](docs/KUBERNETES_ISTIO_ARGO_LVM.md) and [ARGOCD_ISTIOCTL_KPT_PERL.md](docs/ARGOCD_ISTIOCTL_KPT_PERL.md) guides.

### Quick Commands:

* **Docker Compose:**
  ```bash
  docker compose up -d --build
  ```
* **Helm with Istio Gateway & VirtualService:**
  ```bash
  helm upgrade --install heaven-chrome ./helm/heaven-chrome \
    --set istio.enabled=true \
    --set istio.inject=true
  ```
* **Istio Mesh Debugging:**
  ```bash
  ./bin/istioctl analyze
  ./bin/istioctl proxy-status
  ```
* **ArgoCD CLI Connection:**
  ```bash
  ./bin/argocd login localhost:8081 --username admin --insecure
  ./bin/argocd app sync heaven-chrome
  ```

---

## 9. LVM Storage Management

A dedicated 2.62 GiB disk `/dev/sdc` is managed under LVM (`vg_storage/lv_storage`) and mounted at `/mnt/storage`.
* Full details and commands for adding disks to standard LVM root filesystems are documented in [docs/KUBERNETES_ISTIO_ARGO_LVM.md](docs/KUBERNETES_ISTIO_ARGO_LVM.md).

---

## 10. Troubleshooting

### ZX Spectrum / z88dk

| Error | Fix |
|---|---|
| `zcc: command not found` | Run `env.bat` (Windows) or `source env.sh` (Linux) to add z88dk to `PATH`. |
| `wine: command not found` | Install Wine: `sudo apt install wine` |
| Build output missing (`build\chronos.tap`) | Check terminal for compile errors. Ensure all `.c` and `.asm` files listed in `build.bat` exist in `src/`. |
| Fuse opens but game does not start | Tape auto-play may be disabled. In Fuse: **Media → Tape → Play**. |
| Fuse window is too small | Fuse scales to 2x by default. Use **Options → General → Emulation speed** to adjust. |

### Android / Capacitor

| Error | Fix |
|---|---|
| `[fatal] The Capacitor CLI requires NodeJS >=20.0.0` | Upgrade Node.js to v20 LTS. Run `node --version` to confirm. |
| `SDK location not found` | Create `android/local.properties`: `sdk.dir=/home/yourname/Android/Sdk` |
| `ANDROID_HOME is not set` | Export `ANDROID_HOME` in your shell profile and restart your terminal. |
| `./gradlew: Permission denied` | Run `chmod +x android/gradlew` |
| `npx cap sync` copies nothing / empty assets | Confirm `web/index.html` exists — Capacitor copies the directory specified in `webDir`. |
| APK installs but shows blank screen | Run `adb logcat | grep Capacitor` to find WebView errors. |
| APK not installing (`INSTALL_FAILED_UPDATE_INCOMPATIBLE`) | Uninstall the existing app version first: `adb uninstall com.popabogdan.heavenchronos` |

### Web Version

| Problem | Fix |
|---|---|
| Page loads but canvas is blank | Open DevTools (F12) → Console — look for JavaScript errors. |
| Controls unresponsive | Click on the game canvas to focus it before pressing keys. |
| Game runs slowly | Close other tabs; the game is CPU-intensive on older hardware. |
