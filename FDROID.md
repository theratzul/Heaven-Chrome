# F-Droid Publishing Guide for Heaven Chrome

This guide explains how to publish and distribute **Heaven Chrome** on **F-Droid**, the premier free and open-source Android app repository.

---

## 1. Overview & F-Droid Requirements

F-Droid is strictly dedicated to Free and Open-Source Software (FOSS). Heaven Chrome is uniquely well-suited for F-Droid because:
* It has **no proprietary dependencies** (no Google Play Services, no Firebase, no proprietary ads or tracking).
* It is built using standard open-source tools: Node.js, Capacitor, and Android Gradle Plugin.
* It uses an open-source license.

There are **two ways** to distribute on F-Droid:
1. **Official F-Droid Main Repository** (Built directly from your Git source on F-Droid's servers).
2. **Your Own Custom F-Droid Repository** (Fastest: host signed APKs on GitHub Pages or a server).

---

## Method A — Official F-Droid Main Repository Inclusion

When accepted into the official F-Droid catalog, millions of Android users can discover and install Heaven Chrome directly from the F-Droid app.

### Step 1: Ensure Repository Readiness
1. **Clean Open Source License:**
   Ensure your repository contains a standard open-source license file (e.g. `LICENSE` with MIT or GPL-3.0).
2. **Git Tags for Releases:**
   F-Droid detects and builds new versions based on Git release tags:
   ```bash
   git tag -a v1.0.0 -m "Release version 1.0.0"
   git push origin v1.0.0
   ```
3. **Verify Clean Build:**
   Confirm that the app compiles cleanly with Gradle:
   ```bash
   npm install
   npx cap sync android
   cd android && ./gradlew assembleRelease
   ```

### Step 2: Fork the Official `fdroiddata` Repository
1. Go to [https://gitlab.com/fdroid/fdroiddata](https://gitlab.com/fdroid/fdroiddata).
2. Click **Fork** to create your own copy on GitLab.
3. Clone your fork locally:
   ```bash
   git clone https://gitlab.com/YOUR_GITLAB_USERNAME/fdroiddata.git
   cd fdroiddata
   ```

### Step 3: Create the Metadata Recipe
Create a new file `metadata/com.popabogdan.heavenchronos.yml`:

```yaml
Categories:
  - Games
License: MIT
AuthorName: popa bogdan
WebSite: https://github.com/theratzul/Heaven-Chrome
SourceCode: https://github.com/theratzul/Heaven-Chrome
IssueTracker: https://github.com/theratzul/Heaven-Chrome/issues

AutoName: Heaven Chrome
Summary: A Divine Time-Bending Action Adventure
Description: |-
  Heaven Chrome is an action adventure game where players manipulate time to
  guide an angelic soul through 20 perilous heavenly realms. Navigate past demonic
  hazards and reach the Pearly Gates using Divine Grace to slow down time.
  Features an atmospheric polyphonic soundtrack, responsive touch controls, and
  guardian angel collectibles.

RepoType: git
Repo: https://github.com/theratzul/Heaven-Chrome.git

Builds:
  - versionName: 1.0.0
    versionCode: 1
    commit: v1.0.0
    subdir: android
    init:
      - npm install
      - npx cap sync android
    gradle:
      - assembleRelease

AutoUpdateMode: Version
UpdateCheckMode: Tags
CurrentVersion: 1.0.0
CurrentVersionCode: 1
```

### Step 4: Test Your Recipe with `fdroid build`
Install `fdroidserver` tools and test the build in an isolated container:
```bash
sudo apt install fdroidserver
fdroid checkupdates com.popabogdan.heavenchronos
fdroid build -v -l com.popabogdan.heavenchronos
```

### Step 5: Submit a Merge Request
1. Commit and push your recipe to your GitLab fork:
   ```bash
   git checkout -b add-heaven-chrome
   git add metadata/com.popabogdan.heavenchronos.yml
   git commit -m "Add com.popabogdan.heavenchronos"
   git push origin add-heaven-chrome
   ```
2. Open a **Merge Request** against `fdroid/fdroiddata`.
3. The F-Droid automated linter will test your build, and maintainers will merge it. Within a few days, your app will be indexed and available worldwide!

---

## Method B — Host Your Own F-Droid Repository (Instant Distribution)

If you want immediate distribution without waiting for upstream review, you can host your own F-Droid repository on **GitHub Pages**:

### Step 1: Install `fdroidserver`
```bash
sudo apt install -y fdroidserver
```

### Step 2: Initialize Repository
```bash
mkdir ~/heaven-chrome-fdroid
cd ~/heaven-chrome-fdroid
fdroid init
```

### Step 3: Add Your APK
Copy your built and signed `Heaven-Chrome.apk` into the `repo/` directory:
```bash
cp /home/vboxuser/myrepos/Heaven-Chrome/android/app/build/outputs/apk/debug/Heaven-Chrome.apk ~/heaven-chrome-fdroid/repo/
```

### Step 4: Generate Repository Index & Metadata
```bash
fdroid update -c
```
This generates `index-v1.jar`, `index-v1.json`, and repository metadata.

### Step 5: Publish on GitHub Pages
1. Push the contents of `~/heaven-chrome-fdroid/repo/` to the `gh-pages` branch of your GitHub repository.
2. Users can simply add your repository URL in their F-Droid app:
   **F-Droid Settings** → **Repositories** → **(+) Add Repository** → `https://YOUR_USERNAME.github.io/Heaven-Chrome/repo`.
