# Complete Publishing Guide: F-Droid, Google Play, Steam (Windows & Linux)

This tutorial provides step-by-step instructions to register and publish **Heaven Chrome** across all distribution platforms.

---

## 1. Publishing to F-Droid

F-Droid is the premier repository for Free and Open Source Android applications.

### Prerequisites (Already Configured in Repository)
- Repository is public on GitHub: `https://github.com/theratzul/Heaven-Chrome`
- Open-source license (MIT / GPL-compatible)
- No proprietary tracking libraries or advertising SDKs
- Fastlane metadata structure prepared in `fastlane/metadata/android/en-US/`
- Build recipe prepared in `metadata/com.popabogdan.heavenchronos.yml`

### Step-by-Step Submission:
1. **Fork the F-Droid Data Repository**:
   - Go to [https://gitlab.com/fdroid/fdroiddata](https://gitlab.com/fdroid/fdroiddata) and click **Fork**.
2. **Add the Application Recipe**:
   - In your fork, create a new file: `metadata/com.popabogdan.heavenchronos.yml`.
   - Copy the exact contents of `metadata/com.popabogdan.heavenchronos.yml` from this repository.
3. **Verify the Recipe Locally (Optional)**:
   - If you have `fdroidserver` installed:
     ```bash
     fdroid checkupdates com.popabogdan.heavenchronos
     fdroid build -v -l com.popabogdan.heavenchronos
     ```
4. **Open a Merge Request**:
   - Submit a Merge Request from your fork to `fdroid/fdroiddata:master`.
   - Title: `Add com.popabogdan.heavenchronos (Heaven Chrome)`
   - The F-Droid build bot will run automated tests and build your APK from source.
   - Once approved, your application will appear on F-Droid client and website within a few days!

---

## 2. Publishing to Google Play Store

### Prerequisites:
- A Google Play Developer account ($25 one-time registration fee at [play.google.com/console](https://play.google.com/console))
- Signed release APK: `android/app/build/outputs/apk/release/Heaven-Chrome.apk` (or Google Play App Bundle `.aab`)

### Step-by-Step Submission:
1. **Create App in Google Play Console**:
   - Click **Create app**.
   - **App name**: `Heaven Chrome`
   - **Default language**: English (United States)
   - **App or game**: Game
   - **Free or paid**: Free
   - Accept declarations and click **Create app**.
2. **Complete Dashboard Tasks**:
   - **Privacy Policy**: Provide a link to your hosted privacy policy (e.g. GitHub Pages or repo docs).
   - **App Access**: All functionality is available without credentials.
   - **Ads**: Select "No, my app does not contain ads".
   - **Content Ratings**: Complete the IARC questionnaire (Violence: None / Mild Fantasy; Game Type: Casual / Arcade).
   - **Target Audience**: Select 13+ (or all ages).
3. **Store Presence & Graphics**:
   - **Short description**: `A divine time-bending puzzle adventure across 20 heavenly realms.`
   - **Full description**: Copy from `fastlane/metadata/android/en-US/full_description.txt`.
   - **App Icon**: Upload `web/icon.png` (512x512).
   - **Feature Graphic**: Upload 1024x500 banner (can use title banner or screenshot).
   - **Screenshots**: Upload at least 2 phone screenshots (e.g. gameplay, title screen).
4. **Create Release**:
   - Go to **Production** (or **Closed testing** first).
   - Click **Create new release**.
   - Upload `android/app/build/outputs/apk/release/Heaven-Chrome.apk` (or build `.aab` using `./gradlew bundleRelease`).
   - Release name: `1.0.0`
   - Release notes: `Initial divine release of Heaven Chrome.`
   - Click **Next** > **Save** > **Review release** > **Start rollout to Production**.

---

## 3. Publishing to Steam for Windows 11 & Linux (Complete Steamworks & SteamPipe Guide)

### Prerequisites:
1. **Steamworks Partner Account**: Register at [partner.steamgames.com](https://partner.steamgames.com).
2. **Steam Direct Fee**: Purchase a $100 Steam Direct product key for your game.
3. **Application ID (AppID)**: Created after paying the fee (e.g. `1234560`).
4. **Pre-built Game Packages in Repository**:
   - **Windows Package**: Run `./build-windows.sh` -> produces `windows/heaven-chrome-windows.zip` and `windows/bin/heaven-chrome.exe` + `windows/lib/SDL2.dll`.
   - **Linux / Steam Deck Package**: Run `./build-linux.sh` and `make -C linux package` -> produces `linux/heaven-chrome-linux.tar.gz` and `linux/bin/heaven-chrome`.

---

### Step-by-Step Steamworks Registration & App Setup

#### Step 1: Onboarding & Company Verification
1. Sign in to [partner.steamgames.com](https://partner.steamgames.com).
2. Complete the **Onboarding Wizard**:
   - Enter legal entity information (Individual / Sole Proprietor or Company).
   - Complete the **IRS Tax Interview** (W-8BEN for non-US developers or W-9 for US developers).
   - Enter your payout bank details.
3. Pay the **$100 USD Steam Direct Fee** via Steam.

#### Step 2: Create the Application
1. In the Steamworks Dashboard, click **Create New Application**.
2. Select Application Type: **Game**.
3. Name: `Heaven Chrome`.
4. Steam will grant you an **AppID** (e.g., `480` for Spacewar test or your assigned unique 7-digit AppID).

#### Step 3: Configure Store Page & Graphical Assets
Navigate to **Store Admin > Edit Store Page**:
1. **Basic Info**:
   - Title: `Heaven Chrome`
   - Short Description: `A divine time-bending puzzle adventure across 20 heavenly realms. Manipulate time, collect holy grace, and ascend through celestial obstacles.`
   - Genres: `Action`, `Indie`, `Casual`.
   - Tags: `Time Manipulation`, `2D`, `Pixel Graphics`, `Retro`, `Precision Platformer`, `Controller`.
2. **Graphical Assets**:
   - Header Capsule: `460px x 215px` (PNG)
   - Small Capsule: `231px x 87px` (PNG)
   - Main Capsule: `616px x 353px` (PNG)
   - Vertical Capsule: `374px x 448px` (PNG)
   - Page Background: `1438px x 810px`
   - Screenshots: At least 5 gameplay screenshots (800x600 or 1920x1080).

---

### Step-by-Step SteamPipe Depot Setup & Upload

Steam uses **SteamPipe** (`steamcmd`) to manage builds and delta patching.

#### Step 1: Configure Depots in Steamworks Web Dashboard
1. Go to **Steamworks Admin > Installation > Depots**.
2. Create two depots under your AppID:
   - **Windows Depot** (e.g., DepotID `[AppID + 1]`):
     - OS: `Windows`
     - Architecture: `64-bit`
   - **Linux Depot** (e.g., DepotID `[AppID + 2]`):
     - OS: `Linux`
     - Architecture: `64-bit`
3. In **Installation > General Installation**:
   - Check **Windows** and **Linux**.
4. In **Installation > Launch Options**:
   - **Launch Option 0 (Windows)**:
     - Executable: `heaven-chrome.exe`
     - OS: `Windows`
     - CPU: `64-bit`
   - **Launch Option 1 (Linux & Steam Deck)**:
     - Executable: `run.sh`
     - OS: `Linux`
     - CPU: `64-bit`
5. Click **Save** and **Publish to Staging**.

#### Step 2: Prepare the Content Directories Locally
On your build machine:
```bash
# 1. Create Steam content directories
mkdir -p ~/steam_content/windows ~/steam_content/linux

# 2. Copy Windows build files
cp windows/bin/heaven-chrome.exe ~/steam_content/windows/
cp windows/lib/SDL2.dll ~/steam_content/windows/
cp windows/icon.ico ~/steam_content/windows/

# 3. Copy Linux build files
cp linux/bin/heaven-chrome ~/steam_content/linux/
cp linux/run.sh ~/steam_content/linux/
cp linux/heaven-chrome.png ~/steam_content/linux/
chmod +x ~/steam_content/linux/run.sh ~/steam_content/linux/heaven-chrome
```

#### Step 3: SteamPipe VDF Configuration Scripts

Create `scripts/depot_build_windows.vdf`:
```vdf
"DepotBuildConfig"
{
  "DepotID" "YOUR_WINDOWS_DEPOT_ID"
  "FileMapping"
  {
    "LocalPath" "*"
    "DepotPath" "."
    "recursive" "1"
  }
}
```

Create `scripts/depot_build_linux.vdf`:
```vdf
"DepotBuildConfig"
{
  "DepotID" "YOUR_LINUX_DEPOT_ID"
  "FileMapping"
  {
    "LocalPath" "*"
    "DepotPath" "."
    "recursive" "1"
  }
}
```

Create `scripts/app_build.vdf`:
```vdf
"AppBuild"
{
  "AppID" "YOUR_APP_ID"
  "Desc" "Heaven Chrome Release Build v1.0.0"
  "BuildOutput" "../output/"
  "ContentRoot" "../content/"
  "SetLive" "internal_test" // Automatically sets this build to internal testing branch

  "Depots"
  {
    "YOUR_WINDOWS_DEPOT_ID" "depot_build_windows.vdf"
    "YOUR_LINUX_DEPOT_ID"   "depot_build_linux.vdf"
  }
}
```

#### Step 4: Upload to Steam Using `steamcmd`

Install `steamcmd` if not already installed, then execute:

```bash
# Upload build to Steamworks
steamcmd +login <STEAM_DEV_USERNAME> +run_app_build $(pwd)/scripts/app_build.vdf +quit
```

When prompted, enter your Steam password and Steam Guard 2FA code. SteamPipe will hash chunks, upload missing chunks, and commit the build to your Steamworks dashboard.

#### Step 5: Test and Set Live
1. Open the Steam desktop client on Windows 11 or Linux / Steam Deck.
2. In your game's **Properties > Betas**, select branch `internal_test` (or install directly via Steamworks developer account).
3. Verify gameplay, controls, resolution scaling, and gamepad navigation.
4. When ready for release:
   - In Steamworks > **Builds**, promote the build from `internal_test` to **Default (Live)**.
   - Click **Submit for Review** (Valve conducts a brief 2-3 day review before your store page and game launch).

---

## 4. Steam Deck Compatibility Verification

Heaven Chrome is optimized for **Steam Deck (SteamOS 3.x)** out of the box:
- **Zero Proton overhead**: Compiles directly to native 64-bit Linux binary linked dynamically to SteamOS `libSDL2`.
- **Display**: Seamless 16:10 / 16:9 60 FPS rendering.
- **Controller Support**: Native SDL2 GameController API:
  - **Left Analog Stick / D-Pad**: Move spirit orb.
  - **Button [A] / Right Trigger**: Divine Time Shift (slow-motion).
  - **Button [Start]**: Pause / Resume.
  - **Button [Y]**: Toggle Audio Mute.
- Qualifies for the **Steam Deck Verified** green badge.

