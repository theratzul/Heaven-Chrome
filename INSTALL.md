# Heaven Chronos — Installation & Setup Guide

> A complete guide to setting up your development environment and running Heaven Chronos on every supported platform: **ZX Spectrum 48K**, **Web**, and **Android**.

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Platform A — ZX Spectrum 48K (z88dk + Fuse)](#2-platform-a--zx-spectrum-48k-z88dk--fuse)
   - [What Each Tool Does](#21-what-each-tool-does)
   - [Windows Setup](#22-windows-setup)
   - [Linux Setup](#23-linux-setup)
3. [Platform B — Web Browser](#3-platform-b--web-browser)
4. [Platform C — Android (Node.js + Capacitor)](#4-platform-c--android-nodejs--capacitor)
   - [What Each Tool Does](#41-what-each-tool-does)
   - [Windows Setup](#42-windows-setup)
   - [Linux / macOS Setup](#43-linux--macos-setup)
   - [Building the APK](#44-building-the-apk)
5. [CI/CD — GitHub Actions](#5-cicd--github-actions)
6. [Repository Scripts Reference](#6-repository-scripts-reference)
7. [Troubleshooting](#7-troubleshooting)

---

## 1. Project Overview

Heaven Chronos targets three distinct platforms, each requiring a different toolchain:

| Platform | Technology | Output |
|---|---|---|
| ZX Spectrum 48K | C + Z80 ASM → z88dk → `.tap` | Tape image, run in Fuse emulator |
| Web Browser | HTML5 + JavaScript + CSS | Open `web/index.html` directly |
| Android | Web wrapped via Capacitor | `.apk` installable on any Android device |

---

## 2. Platform A — ZX Spectrum 48K (z88dk + Fuse)

The ZX Spectrum version is the original version of Heaven Chronos. The game source code lives in `src/` and is written in **C** (game logic) and **Z80 Assembly** (engine routines). It is compiled by **z88dk** into a `.tap` tape image that runs in the **Fuse** emulator.

### 2.1 What Each Tool Does

#### z88dk — The Z80 Cross-Compiler Toolchain
**Location in repo:** `tools/z88dk/`

z88dk is a complete C and Z80 assembly development kit targeting 8-bit Z80-based computers. It includes:

- **`zcc`** — The compiler driver. It orchestrates the entire build pipeline: preprocessing, C compilation (via SDCC), assembly, linking, and tape image creation. The build command uses these key flags:
  - `+zx` — targets the ZX Spectrum platform
  - `-startup=1` — uses the standard ROM-based startup (BASIC loader)
  - `-clib=sdcc_iy` — uses the SDCC-compatible C library (IY register-based)
  - `-SO3 --max-allocs-per-node200000` — aggressive size/speed optimization
  - `-pragma-define:CRT_ORG_CODE=0x8000` — places game code at address 32768 in RAM
  - `-pragma-define:REGISTER_SP=0xD000` — sets the stack pointer
  - `-create-app` — produces a `.tap` / `.tzx` tape image as final output

- **`ZCCCFG`** — Environment variable pointing to z88dk's library config directory. Required for `zcc` to locate platform headers and libraries.

- **`Z80_OZFILES`** — Environment variable pointing to compiled C library objects. Required at link time.

The `env.bat` / `env.sh` scripts set all these environment variables so `zcc` can be called from anywhere.

#### Fuse — The ZX Spectrum Emulator
**Location in repo:** `tools/fuse/`

Fuse (Free Unix Spectrum Emulator) is the most accurate and feature-rich open-source ZX Spectrum emulator. It emulates the original Spectrum hardware cycle-accurately, including:

- The **Z80 CPU** (all undocumented opcodes)
- **ULA** (Uncommitted Logic Array) — the chip responsible for video output, keyboard scanning, and the tape interface
- **AY-3-8912** sound chip (for 128K models; 48K uses the single-channel beeper)
- **Border** colour effects timed to the video frame

Heaven Chronos targets the **48K** model. The `--machine 48` flag tells Fuse to emulate the original 48K Spectrum. The `--tape` flag loads the compiled `.tap` file and auto-plays it (equivalent to `LOAD ""` on a real machine).

---

### 2.2 Windows Setup

**Prerequisites:** Windows 10 or later.

#### Step 1 — Clone the repository
```bat
git clone https://github.com/theratzul/Heaven-Chrome.git
cd Heaven-Chronos
```

#### Step 2 — Set up the environment
The compiler and emulator are bundled in `tools/`. Simply run the environment script to register the paths:

```bat
env.bat
```

This sets `PATH`, `ZCCCFG`, and `Z80_OZFILES` for the current terminal session, pointing to `tools\z88dk\`.

#### Step 3 — Build
```bat
build.bat
```

The compiled tape image will be saved to `build\chronos.tap`.

#### Step 4 — Run in Fuse
```bat
run.bat
```

This calls `build.bat` and then launches `tools\fuse\fuse.exe --machine 48 --tape build\chronos.tap`.

---

### 2.3 Linux Setup

On Linux, the `.bat` scripts are executed through **Wine** (a Windows compatibility layer), which is the simplest way to run the bundled Windows builds of z88dk and Fuse. Alternatively, you can install native Linux versions.

#### Option A — Using Wine (Simplest, uses bundled tools)

**Install Wine:**
```bash
# Ubuntu / Debian
sudo apt update && sudo apt install wine

# Fedora
sudo dnf install wine

# Arch Linux
sudo pacman -S wine
```

**Build and run:**
```bash
source env.sh   # Sets up env via wine cmd
./build.sh      # Compiles via wine cmd → build.bat
./run.sh        # Builds and launches Fuse
```

#### Option B — Native Linux z88dk + Fuse

**Install z88dk (native):**
```bash
# Ubuntu / Debian (from package manager, may be older version)
sudo apt install z88dk

# Or build from source for the latest version:
sudo apt install git make gcc libboost-dev texinfo bison flex libxml2-dev
git clone --recursive https://github.com/z88dk/z88dk.git
cd z88dk
chmod +x build.sh && ./build.sh
```

Set environment variables manually:
```bash
export Z88DK=/path/to/z88dk
export ZCCCFG=$Z88DK/lib/config
export Z80_OZFILES=$Z88DK/lib/clibs
export PATH=$Z88DK/bin:$PATH
```

**Install Fuse (native):**
```bash
# Ubuntu / Debian
sudo apt install fuse-emulator-gtk

# Arch Linux
sudo pacman -S fuse-emulator

# Fedora
sudo dnf install fuse-emulator

# macOS (Homebrew)
brew install fuse-emulator
```

**Build and run:**
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

The Web version is the simplest to run — it requires **no build process** and **no installation**.

### What the Web Version Is

The `web/` directory contains a self-contained HTML5 Canvas game. It is a faithful port of the ZX Spectrum version with enhanced graphics and the same core mechanics (Divine Time Shift, Faith Score, Pearly Gates progression). It runs entirely in the browser's JavaScript engine.

### Running Locally

1. Open your file manager and navigate to the `web/` directory.
2. Double-click `index.html` — it will open in your default browser.
3. That's it. No server, no build step, no dependencies.

### Supported Browsers

| Browser | Support |
|---|---|
| Chrome / Chromium 90+ | ✅ Full support |
| Firefox 88+ | ✅ Full support |
| Edge 90+ | ✅ Full support |
| Safari 14+ | ✅ Full support |
| Internet Explorer | ❌ Not supported |

---

## 4. Platform C — Android (Node.js + Capacitor)

The Android version wraps the Web version in a native Android application shell using **Capacitor**. The game logic is identical to the Web version — Capacitor simply provides the native WebView container, access to Android APIs, and the ability to package the app as an `.apk`.

### 4.1 What Each Tool Does

#### Node.js (≥ 20.0.0 LTS)
Node.js is the JavaScript runtime used to run the Capacitor CLI and npm (the Node Package Manager). It is not used at runtime in the Android app — it is only needed during the build phase to run tooling scripts.

- **npm** — Node's package manager. Running `npm install` reads `package.json` and downloads all declared dependencies (Capacitor packages) into `node_modules/`.
- **npx** — npm's script runner. `npx cap` runs the locally-installed Capacitor CLI from `node_modules/.bin/cap` without needing a global install.

> **Why ≥ 20?** The Capacitor CLI (`@capacitor/cli ^7.x`) dropped support for Node < 20. Using Node 18 or earlier causes a fatal error during `npx cap sync`.

#### Capacitor CLI (`@capacitor/cli`)
Capacitor is Ionic's open-source native runtime that bridges web apps and mobile platforms. The CLI provides:

- **`npx cap sync android`** — Copies the web app from `web/` (the `webDir` defined in `capacitor.config.json`) into the Android project's assets directory (`android/app/src/main/assets/public/`), and updates any native plugins. This is the critical step that embeds your web game into the Android shell.
- **`npx cap open android`** — Opens the `android/` project in Android Studio.
- **`npx cap add android`** — (Initial setup only) Generates the `android/` native project structure.

The Capacitor configuration (`capacitor.config.json`) defines:
```json
{
  "appId": "com.popabogdan.heavenchronos",
  "appName": "Heaven Chronos",
  "webDir": "web"
}
```
- **`appId`** — The reverse-domain application ID, used by Android to uniquely identify the app on a device.
- **`webDir`** — The directory whose contents are copied into the Android WebView.

#### Gradle / Android SDK
The `android/` directory is a standard Android Gradle project. `./gradlew assembleDebug` uses the Gradle wrapper to download all Android dependencies and compile the APK. You do **not** need Android Studio installed to build — only the **Java JDK 21** (for the Gradle JVM) and the **Android SDK** (auto-managed by Gradle if `ANDROID_HOME` is set).

---

### 4.2 Windows Setup

#### Step 1 — Install Node.js ≥ 20 LTS

1. Go to [https://nodejs.org](https://nodejs.org) and download the **LTS** installer (currently v20.x or v22.x).
2. Run the installer, making sure **"Add to PATH"** is checked.
3. Verify:
   ```bat
   node --version   :: Should print v20.x.x or higher
   npm --version
   ```

#### Step 2 — Install Java JDK 21

1. Download **Temurin JDK 21** from [https://adoptium.net](https://adoptium.net).
2. Run the installer.
3. Verify:
   ```bat
   java --version   :: Should print openjdk 21...
   ```

#### Step 3 — Install Android SDK

**Option A — Via Android Studio (Recommended):**
1. Download Android Studio from [https://developer.android.com/studio](https://developer.android.com/studio).
2. Install it and open **SDK Manager** → install **Android SDK Platform 34** (or latest).
3. Note the SDK path (e.g. `C:\Users\YourName\AppData\Local\Android\Sdk`).

**Option B — Command-line tools only:**
1. Download "Command line tools only" from the Android Studio download page.
2. Extract to a folder (e.g. `C:\Android\cmdline-tools\latest\`).
3. Run: `sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"`

Set the environment variable:
```bat
setx ANDROID_HOME "C:\Users\YourName\AppData\Local\Android\Sdk"
setx PATH "%PATH%;%ANDROID_HOME%\platform-tools"
```

#### Step 4 — Install dependencies and sync

```bat
cd Heaven-Chronos
npm install
npx cap sync android
```

#### Step 5 — Build the APK

```bat
cd android
gradlew.bat assembleDebug
```

The APK is output to:
```
android\app\build\outputs\apk\debug\app-debug.apk
```

---

### 4.3 Linux / macOS Setup

#### Step 1 — Install Node.js ≥ 20 LTS

**Using nvm (recommended — avoids permission issues):**
```bash
# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.bashrc   # or ~/.zshrc

# Install and use Node 20 LTS
nvm install 20
nvm use 20
node --version     # Should print v20.x.x
```

**Using package manager:**
```bash
# Ubuntu / Debian
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# Arch Linux
sudo pacman -S nodejs npm

# macOS (Homebrew)
brew install node@20
```

#### Step 2 — Install Java JDK 21

```bash
# Ubuntu / Debian
sudo apt install openjdk-21-jdk

# Arch Linux
sudo pacman -S jdk21-openjdk

# macOS (Homebrew)
brew install openjdk@21

# Verify
java --version
```

#### Step 3 — Install Android SDK

**Option A — Via Android Studio:**
Download from [https://developer.android.com/studio](https://developer.android.com/studio), install, then add to your shell profile (`~/.bashrc` or `~/.zshrc`):
```bash
export ANDROID_HOME=$HOME/Android/Sdk            # Linux
export ANDROID_HOME=$HOME/Library/Android/sdk    # macOS
export PATH=$PATH:$ANDROID_HOME/platform-tools
```

**Option B — Command-line tools only (Linux):**
```bash
mkdir -p ~/Android/cmdline-tools/latest
# Download commandlinetools-linux-*.zip from https://developer.android.com/studio#command-line-tools-only
unzip commandlinetools-linux-*.zip -d ~/Android/cmdline-tools/latest/

# Accept licenses and install SDK components
yes | ~/Android/cmdline-tools/latest/bin/sdkmanager --licenses
~/Android/cmdline-tools/latest/bin/sdkmanager \
    "platform-tools" "platforms;android-34" "build-tools;34.0.0"

# Add to ~/.bashrc
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools
```

#### Step 4 — Install dependencies and sync

```bash
cd Heaven-Chronos
npm install
npx cap sync android
```

#### Step 5 — Build the APK

```bash
cd android
chmod +x gradlew
./gradlew assembleDebug
```

The APK is output to:
```
android/app/build/outputs/apk/debug/app-debug.apk
```

**Install directly on a connected Android device:**
```bash
adb install android/app/build/outputs/apk/debug/app-debug.apk
```

---

### 4.4 Building the APK

Once all prerequisites are installed, the full build pipeline is:

```bash
npm install              # 1. Download Capacitor packages
npx cap sync android     # 2. Copy web/ into android/ assets
cd android
./gradlew assembleDebug  # 3. Compile the APK
```

#### Debug vs Release

| Build Type | Command | Notes |
|---|---|---|
| Debug | `./gradlew assembleDebug` | Signed with a debug keystore. Sideloadable on any device with "Unknown sources" enabled. |
| Release | `./gradlew assembleRelease` | Requires a signing keystore. Required for Play Store distribution. |

---

## 5. CI/CD — GitHub Actions

The repository includes an automated build pipeline at [`.github/workflows/android.yml`](.github/workflows/android.yml).

### What it does

On every `push` or `pull_request` to `main`/`master` (and manual trigger via **Run workflow**):

1. **Checks out** the repository
2. **Sets up Node.js 20** (LTS — satisfies Capacitor CLI ≥ 20 requirement)
3. **Sets up JDK 21** (Temurin distribution — required by Gradle)
4. **Runs `npm install`** to fetch Capacitor packages
5. **Runs `npx cap sync android`** to embed the web game into the Android project
6. **Runs `./gradlew assembleDebug`** to compile the APK
7. **Uploads `app-debug.apk`** as a downloadable workflow artifact (available under Actions → your run → Artifacts)

### Manual trigger

Go to your repository on GitHub → **Actions** tab → **Build Android** → **Run workflow** → select branch → click **Run workflow**.

---

## 6. Repository Scripts Reference

| Script | Platform | Description |
|---|---|---|
| `env.bat` | Windows | Sets `PATH`, `ZCCCFG`, `Z80_OZFILES` for z88dk. Run once per terminal session before building. |
| `env.sh` | Linux | Wrapper — delegates to `env.bat` via Wine. |
| `build.bat` | Windows | Calls `env.bat` then compiles with `zcc`. Outputs `build/chronos.tap`. |
| `build.sh` | Linux | Wrapper — delegates to `build.bat` via Wine. |
| `run.bat` | Windows | Builds and launches Fuse with the compiled tape. |
| `run.sh` | Linux | Builds and launches Fuse (tries system Fuse → `tools/fuse/fuse` → Wine Fuse). |

---

## 7. Troubleshooting

### ZX Spectrum / z88dk

| Problem | Fix |
|---|---|
| `zcc: command not found` | Run `env.bat` / `source env.sh` first to add z88dk to PATH. |
| `wine: command not found` (Linux) | Install Wine: `sudo apt install wine` |
| Build fails with undefined symbols | Make sure all `.c` and `.asm` source files are listed in the build command. |
| Fuse not found | Install `fuse-emulator-gtk` via your package manager, or ensure `tools/fuse/fuse.exe` exists. |

### Android / Capacitor

| Problem | Fix |
|---|---|
| `[fatal] The Capacitor CLI requires NodeJS >=20.0.0` | Upgrade Node.js to v20 LTS or later. See Section 4.2/4.3. |
| `ANDROID_HOME is not set` | Set the `ANDROID_HOME` environment variable to your Android SDK path. |
| `SDK location not found` | Create `android/local.properties` with: `sdk.dir=/path/to/your/Android/Sdk` |
| `./gradlew: Permission denied` (Linux/macOS) | Run `chmod +x android/gradlew` |
| APK builds but crashes on device | Run `adb logcat` to inspect runtime errors in the WebView. |
| `npx cap sync` fails silently | Ensure `web/index.html` exists — Capacitor copies the `webDir` (`web/`) into the Android assets. |

### Web Version

| Problem | Fix |
|---|---|
| Blank screen / nothing loads | Open browser DevTools (F12) → Console tab and check for errors. |
| Game runs but controls do not work | Click on the game canvas first to give it keyboard focus. |
