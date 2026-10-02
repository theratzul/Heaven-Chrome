# Heaven Chrome — Installation & Setup Guide

> A complete guide to setting up your development environment and running Heaven Chrome on every supported platform: **ZX Spectrum 48K**, **Web**, and **Android**.

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Platform A — ZX Spectrum 48K (z88dk + Fuse)](#2-platform-a--zx-spectrum-48k-z88dk--fuse)
3. [Platform B — Web Browser](#3-platform-b--web-browser)
4. [Platform C — Android (Node.js + Capacitor)](#4-platform-c--android-nodejs--capacitor)
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

APK location: `android\app\build\outputs\apk\debug\app-debug.apk`

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

APK location: `android/app/build/outputs/apk/debug/app-debug.apk`

**Install to a connected device:**
```bash
adb install android/app/build/outputs/apk/debug/app-debug.apk
```

---

### 4.4 Debug vs Release APK

| Type | Gradle command | Signing | Use case |
|---|---|---|---|
| Debug | `./gradlew assembleDebug` | Auto-signed with debug keystore | Sideloading, testing |
| Release | `./gradlew assembleRelease` | Requires your own keystore | Play Store distribution |

---

## 5. CI/CD — GitHub Actions

**Workflow file:** [`.github/workflows/android.yml`](.github/workflows/android.yml)

### Triggers

| Event | Description |
|---|---|
| `push` to `main` / `master` | Runs automatically on every commit |
| `pull_request` to `main` / `master` | Runs on every PR targeting main |
| `workflow_dispatch` | Manual trigger from the GitHub Actions UI |

### Pipeline Steps

| Step | Action | Why |
|---|---|---|
| Checkout | `actions/checkout@v4` | Fetch the repository code |
| Setup Node.js 20 | `actions/setup-node@v4` with `node-version: '20'` | Satisfies Capacitor CLI >= 20 requirement |
| Setup JDK 21 | `actions/setup-java@v4` with `java-version: '21'`, `distribution: 'temurin'` | Required by Gradle to compile the Android project |
| Install dependencies | `npm install` | Downloads `@capacitor/cli`, `@capacitor/core`, `@capacitor/android` |
| Sync Capacitor | `npx cap sync android` | Copies `web/` into the Android project assets |
| Build APK | `cd android && ./gradlew assembleDebug` | Compiles the debug APK |
| Upload artifact | `actions/upload-artifact@v4` | Makes `app-debug.apk` downloadable from the Actions run page |

### Downloading the APK

After a successful run: **Actions tab** → click the run → scroll to **Artifacts** → download **`app-debug`**.

---

## 6. Repository Scripts Reference

| Script | OS | What it does |
|---|---|---|
| [`env.bat`](env.bat) | Windows | Adds `tools\z88dk\bin` to `PATH`; sets `ZCCCFG` and `Z80_OZFILES`. Must be called before building. |
| [`env.sh`](env.sh) | Linux | Delegates to `env.bat` via `wine cmd /c env.bat`. |
| [`build.bat`](build.bat) | Windows | Calls `env.bat`, then runs `zcc` with all source files. Outputs `build\chronos.tap`. |
| [`build.sh`](build.sh) | Linux | Delegates to `build.bat` via `wine cmd /c build.bat`. |
| [`run.bat`](run.bat) | Windows | Calls `build.bat`, then launches Fuse with `--machine 48 --tape build\chronos.tap`. |
| [`run.sh`](run.sh) | Linux | Calls `build.sh`, then launches Fuse (system Fuse → `tools/fuse/fuse` → Wine Fuse fallback). |

---

## 7. Troubleshooting

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
