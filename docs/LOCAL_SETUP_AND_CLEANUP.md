# Local Setup, Disk Optimization & Multi-Platform Development Guide

This document covers system maintenance, Antigravity IDE configuration, Java desktop development, Android testing without Android Studio, and Git credential management for **Heaven Chrome**.

---

## 1. System Disk Cleanup & Optimization

When working with multi-platform builds (Docker, Kubernetes/Kind, Android SDK, Gradle, C cross-compilers, and Node.js), disk usage can grow quickly. Below is a breakdown of disk space that can be reclaimed safely:

### Reclaimable Space Breakdown

| Location / Component | Typical Size | Recommended Cleanup Command | Safe? |
| :--- | :--- | :--- | :--- |
| **`~/Downloads`** | ~644 MB | `rm ~/Downloads/*.deb ~/Downloads/*.msixbundle` | ✅ Yes (already installed) |
| **Gradle Version Caches** | ~1.3 GB | `rm -rf ~/.gradle/caches/8.9` | ✅ Yes (re-downloads on demand) |
| **Docker Dangling Images** | ~1.39 GB | `docker image prune -f` | ✅ Yes (only removes dangling layers) |
| **NPM Cache** | ~757 MB | `npm cache clean --force` | ✅ Yes (verified package cache) |
| **APT Package Cache** | ~94 MB | `sudo apt-get clean` | ✅ Yes (clears downloaded debs) |
| **Systemd Journal Logs** | ~500 MB - 1 GB | `sudo journalctl --vacuum-time=1d` | ✅ Yes (clears old logs) |
| **Git Untracked `node_modules`** | 2,009 files | `git rm -r --cached node_modules` | ✅ Done (prevents repo bloat) |

### One-Liner Safe Cleanup Script

To quickly reclaim **over 3 to 4 GB** of disk space:

```bash
# 1. Clean downloaded installer packages
rm -f ~/Downloads/*.deb ~/Downloads/*.msixbundle

# 2. Clean apt package archives
sudo apt-get clean

# 3. Prune old system logs older than 1 day
sudo journalctl --vacuum-time=1d

# 4. Clean unused Docker image layers
docker image prune -f

# 5. Clean npm cache
npm cache clean --force
```

---

## 2. Git & GitHub Configuration (Credentials & Secrets)

### Credential Helper Setup

Git credentials are configured using the persistent store helper on Linux:

```bash
# Enable credential helper store
git config --global credential.helper store

# Verify Git user identity
git config --global user.name "theratzul"
git config --global user.email "your_email@example.com"
```

### How Credential Storage Works

When you authenticate with GitHub using a Personal Access Token (PAT), Git saves the credentials securely in `~/.git-credentials` with restricted permissions (`chmod 600 ~/.git-credentials`):

```text
https://theratzul:<YOUR_GITHUB_PERSONAL_ACCESS_TOKEN>@github.com
```

> [!IMPORTANT]
> **Security Notice**: Never commit `~/.git-credentials` or raw PAT tokens into repository tracking, commit messages, or public docs. The credential file is kept in your home directory and excluded by `.gitignore`.

### Removing `node_modules` from Git & GitHub

`node_modules` was previously committed to the Git index. We untracked it so that future commits and GitHub pushes stay lightweight:

```bash
# Untrack node_modules without deleting local files
git rm -r --cached node_modules

# Ensure .gitignore includes node_modules/
grep -q "node_modules/" .gitignore || echo "node_modules/" >> .gitignore

# Commit the removal
git commit -m "chore: untrack node_modules from git index"
```

---

## 3. Java Desktop Edition (OpenJDK 21)

Heaven Chrome now includes a **pure Java 2D + Swing** desktop edition running directly in the repository with zero external dependencies.

### Architecture

- **Engine** (`java/src/main/java/com/heavenchrome/GameEngine.java`): Mirroring the exact 60 FPS physics, player movement, collision detection, time dilation (slow-motion), particle system, and 20 divine realms.
- **Synthesizer** (`java/src/main/java/com/heavenchrome/SoundSynth.java`): Pure procedural audio tone generator using `javax.sound.sampled`.
- **Renderer** (`java/src/main/java/com/heavenchrome/GamePanel.java`): Smooth antialiased Java 2D rendering with custom celestial gradients, sunrays, and dialog layouts.
- **Launcher** (`java/src/main/java/com/heavenchrome/Main.java`): Event dispatch thread window initialization with celestial golden halo application icon.

### Building & Running

```bash
# Compile and package executable JAR (java/bin/heaven-chrome.jar)
./build-java.sh

# Run the Java desktop game
./run-java.sh
# or directly:
java -jar java/bin/heaven-chrome.jar
```

---

## 4. Testing Android Builds Without Android Studio

You do **not** need Android Studio installed to build, deploy, test, and debug Android APKs. The Android SDK command-line tools and ADB are already installed locally at `/home/vboxuser/android-sdk`.

### Automated ADB Test Script

We created `tools/android-test-adb.sh`. When run, it:
1. Detects connected physical Android devices or emulators via `adb devices -l`.
2. Automatically builds the debug APK if not present (`./build-android.sh`).
3. Installs `android/app/build/outputs/apk/debug/Heaven-Chrome.apk` on the device.
4. Launches the game (`com.heavenchrome.app`).
5. Streams real-time filtered logcat logs directly in your terminal.

```bash
./tools/android-test-adb.sh
```

### Connecting Your Android Device Without Android Studio

#### Option A: USB Cable (Recommended)
1. On your phone, go to **Settings > About Phone** and tap **Build Number** 7 times to enable **Developer Options**.
2. Go to **Settings > Developer Options** and enable **USB Debugging**.
3. Plug in the USB cable and tap **Allow USB Debugging** on the phone screen.
4. Run `./tools/android-test-adb.sh`.

#### Option B: Wireless ADB (Wi-Fi)
1. Ensure your phone and Linux PC are on the same local Wi-Fi.
2. In **Settings > Developer Options > Wireless Debugging**, tap "Pair device with pairing code".
3. Run in terminal:
   ```bash
   adb pair <PHONE_IP>:<PAIRING_PORT> <CODE>
   adb connect <PHONE_IP>:<CONNECT_PORT>
   ./tools/android-test-adb.sh
   ```

---

## 5. Antigravity IDE Integration

Your Antigravity IDE workspace is configured with first-class tasks, launch profiles, and settings in `.vscode/`:

### Tasks (`.vscode/tasks.json`)

Press `Ctrl+Shift+B` or open the Command Palette (`Ctrl+Shift+P` > `Tasks: Run Task`):
- **`Build All (Java, Linux, Windows, Android)`** — Compiles all targets simultaneously.
- **`Java: Build JAR`** — Recompiles Java sources into `java/bin/heaven-chrome.jar`.
- **`Java: Run Desktop App`** — Runs the Java game.
- **`Linux: Build & Run Native C App`** — Compiles and launches native Linux binary.
- **`Windows: Build & Run in Wine`** — Compiles with MinGW and tests in Wine.
- **`Android: Build Debug & Release APK`** — Runs Capacitor sync and Gradle.
- **`Android: Test via ADB (No Android Studio)`** — Installs and runs APK on connected device.
- **`Kubernetes: Port-Forward ArgoCD`** — Opens ArgoCD dashboard at `https://localhost:8080`.
- **`Kubernetes: Port-Forward Web App`** — Opens K8s web pod at `http://localhost:8081`.

### Launch & Debugging (`.vscode/launch.json`)

- **`Launch Heaven Chrome (Java)`**: Full Java debugging with breakpoints, variable inspection, and step execution.
- **`Launch Heaven Chrome (Linux C)`**: GDB native C debugging for `linux/bin/heaven-chrome`.

---

## 6. Main Menu & HUD Overlap Resolution

In both the Linux (`linux/src/render.c`) and Windows (`windows/src/render.c`) native apps, UI overlapping issues were fixed:

1. **Title Screen Button Overlap**:
   - *Previous Issue*: The action button was 360px wide (`{220, 400, 360, 48}`), while the text `"PRESS SPACE OR [A] TO ASCEND"` at scale 2 is 448px wide, spilling 44px outside each button boundary.
   - *Fix*: Expanded the button to 520px (`{140, 390, 520, 52}`) with 36px clean horizontal margins on both sides, and vertically centered text at y=408.
2. **Controls Panel**:
   - Aligned the panel to 520px (`{140, 185, 520, 175}`) so all control hints and objective text fit with ample margins.
3. **Game Over Screen Overlap**:
   - *Previous Issue*: The game over dialog was 440px wide, while `"PRESS SPACE OR [A] TO RESURRECT"` was 496px wide, causing text overflow.
   - *Fix*: Expanded the dialog to 540px (`{130, 140, 540, 290}`) and added a dedicated resurrection action button (`{140, 310, 520, 48}`).
4. **Upper HUD Stats Formatting**:
   - The upper HUD banner was contained within rows 0–24 (`{10, 2, SCREEN_W - 20, 22}`), ensuring level tiles never collide with realm, faith score, lives, grace bar, or audio status.
