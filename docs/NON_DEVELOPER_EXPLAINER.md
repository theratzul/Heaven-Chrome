# Heaven Chrome - Simple Plain-English Guide (For Non-Developers)

Welcome! This guide explains what every single file, folder, and parameter in this project actually does, using simple, real-world analogies without confusing jargon.

---

## 1. What is Heaven Chrome?

**Heaven Chrome** is two things at once:
1. **A retro celestial video game**: You control a character moving through 20 divine realms, collecting keys, avoiding traps, and slowing down time with an hourglass (`⏳`).
2. **A state-of-the-art software demonstration**: It shows how a single project can run as a retro 1982 computer tape, a modern website, a native desktop application, a mobile phone app, and a resilient cloud service.

---

## 2. The Main Files & Folders Explained

### The Game Itself
* **`web/`**: The website version of the game.
  * `index.html`: The skeleton and layout of the webpage.
  * `style.css`: The paintbrush and styling (colors, golden buttons, animations).
  * `script.js`: The brain and engine of the game (handles physics, jumping, and sound).
* **`android/`**: The Android mobile version.
  * `Heaven-Chrome.apk`: The installer file for your Android phone (just like a `.exe` installer on Windows).
* **`linux/` & `windows/`**: Native desktop game versions that run directly on Linux (SteamOS / Steam Deck) and Windows 11 with full gamepad and high-definition support.
* **`java/`**: A pure Java edition that runs on any desktop with Java installed.
* **`src/`**: The vintage 1982 ZX Spectrum version written in C and assembly language.

---

### The Web Servers & Download Portals
* **`flask_app/` (Python Server)**:
  * A lightweight server written in Python. When you run `./run-flask.sh`, your computer starts a web server so you or anyone on your home Wi-Fi can play the game in a browser and download the phone app.
* **`perl_app/` (Perl Server)**:
  * The exact same idea as the Python server, but written in Perl. You start it with `./run-perl.sh`. It has zero outside dependencies and works instantly.

---

### Cloud, Containers & Infrastructure
* **`Dockerfile`**:
  * **Analogy:** A recipe card for baking a miniature self-contained virtual computer.
  * It takes the game's website files and packs them into a lightweight, secure container called `heaven-chrome:latest`.
* **`docker-compose.yml`**:
  * **Analogy:** A one-button remote control.
  * Running `docker compose up -d` turns on the container in the background without needing to remember long terminal commands.
* **`helm/`**:
  * **Analogy:** Pre-packaged Lego building kits for Kubernetes.
  * Inside `helm/heaven-chrome/`, the templates describe how many copies of the game to start and how to route internet traffic to them.
* **`kpt/`**:
  * **Analogy:** Rubber-stamp blueprints.
  * It provides clean, direct Kubernetes files without dynamic templating so you can inspect exactly what is being sent to the server.
* **`k8s/` and ArgoCD**:
  * **Analogy:** An automatic autopilot robot.
  * ArgoCD constantly watches your project. If you make a change, it automatically updates your servers in seconds.
* **Istio (Service Mesh)**:
  * **Analogy:** A smart traffic cop and private security guard.
  * It sits in front of all servers, verifies incoming network traffic, guards against crashes, and steers players to the fastest running server.

---

## 3. Explaining All Settings in `values.yaml`

In `helm/heaven-chrome/values.yaml`, there are settings you can customize. Here is what every setting means:

| Parameter | What it Does in Plain English | Default Value | Why It Matters |
|---|---|---|---|
| **`replicaCount`** | How many identical copies of the game run at the same time. | `2` | If one crashes, the other takes over instantly with zero downtime. |
| **`image.repository`** | The name of the software package container to run. | `heaven-chrome` | Tells the system which game image to load. |
| **`image.tag`** | The version number label. | `"latest"` | Lets you pick an exact release (e.g. `1.0.0`) or always use the newest. |
| **`service.port`** | The digital "door number" where traffic enters. | `80` | Standard HTTP web door number. |
| **`resources.limits.memory`** | The maximum memory (RAM) one copy can consume. | `128Mi` | Prevents the game from ever freezing the host computer. |
| **`resources.limits.cpu`** | The maximum processor power one copy can use. | `250m` (25% of 1 CPU core) | Keeps the server cool and efficient. |
| **`livenessProbe`** | The server's "heartbeat monitor". | Checks `/` every 10 seconds | If the game stops answering, the system automatically reboots it. |
| **`readinessProbe`** | The "ready to play" check. | Checks `/` on startup | Prevents sending visitors to the game until it has completely loaded. |
| **`istio.enabled`** | Turns on the Istio smart traffic cop. | `true` | Gives advanced routing, security, and traffic metrics. |
| **`istio.inject`** | Attaches a sidecar guardian proxy to the game. | `true` | Allows Istio to protect the game container. |

---

## 4. Hardware Storage & LVM (`/mnt/storage`)

* **What is LVM?**
  * Think of LVM (Logical Volume Manager) as a **flexible digital suitcase**.
  * On a normal computer, hard drives are rigid partitions. With LVM, you can add new physical hard drives into a single big pool without reinstalling the operating system.
* **Why do we have `/mnt/storage`?**
  * When your main disk (`/dev/sda1`) starts getting full, our newly added disk was created as an LVM volume and mounted at `/mnt/storage`.
  * Heavy items like the Android SDK, phone emulators, and disk backups live on `/mnt/storage` so your main operating system never runs out of room!

---

## 5. Helpful Single-Command Cheat Sheet

| I want to... | Just run this command: |
|---|---|
| **Play in browser via Perl** | `./run-perl.sh` (then open `http://localhost:5050`) |
| **Play in browser via Python** | `./run-flask.sh` (then open `http://localhost:5000`) |
| **Download APK to my phone** | Open `http://<PC_IP>:5050/download` on your phone |
| **Install game on phone via USB cable** | `./install-phone.sh` |
| **Start phone emulator & mirror screen** | `./tools/run-emulator.sh` |
| **Check ArgoCD server & login** | `./tools/argocd-connect.sh` |
| **Check Istio traffic cop health** | `./tools/istioctl-check.sh` |
| **Reinstall everything from zero** | `./tools/setup-linux-from-scratch.sh` |
