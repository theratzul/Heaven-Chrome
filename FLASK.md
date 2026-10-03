# Flask Local Setup & Mobile APK Installation Guide

This guide covers all steps to set up and run the local **Flask Web Server** and how to install and test **Heaven-Chrome.apk** on your Android phone (via cable or wireless).

---

## 1. Flask Local Setup (Step-by-Step)

The Flask app (`flask_app/app.py`) provides:
1. Local hosting of the HTML5 Canvas game with real-time sound synthesis.
2. Direct wireless APK download endpoint (`/download`) so any phone on your local network can install `Heaven-Chrome.apk` instantly through its web browser.

### Option A — Quick Start (Automated Script)
Run the root launch script. It automatically creates a Python virtual environment, installs dependencies, and boots the server:
```bash
./run-flask.sh
```

### Option B — Manual Step-by-Step Setup
1. **Navigate to the Flask directory:**
   ```bash
   cd flask_app
   ```
2. **Create Python virtual environment:**
   ```bash
   python3 -m venv venv
   ```
3. **Activate the virtual environment:**
   ```bash
   source venv/bin/activate
   ```
4. **Install requirements:**
   ```bash
   pip install --upgrade pip
   pip install -r requirements.txt
   ```
5. **Run the Flask application:**
   ```bash
   python3 app.py
   ```

### Accessing the Flask Server:
* **Web Game (Local):** [http://localhost:5000](http://localhost:5000)
* **Direct APK Download:** [http://localhost:5000/download](http://localhost:5000/download)
* **System Status API:** [http://localhost:5000/api/status](http://localhost:5000/api/status)
* **LAN Access (From Phone on same Wi-Fi):** `http://<your-computer-ip>:5000/`

---

## 2. Installing APK on Your Phone (via Cable)

Because your development environment is running inside a **VirtualBox Linux VM**, follow these steps to allow ADB to communicate directly with your phone over the USB cable:

### Step 1: Enable USB Debugging on Your Phone
1. Open **Settings** on your phone (e.g. Samsung Galaxy S24).
2. Go to **About phone** → **Software information**.
3. Tap **Build number** 7 times until you see *"Developer mode has been enabled"*.
4. Return to **Settings** → **Developer options** → toggle **USB debugging** to **ON**.

### Step 2: Pass Phone USB Connection to VirtualBox
1. Connect your phone to your computer via USB cable.
2. In the **VirtualBox window top menu bar**, click:
   **Devices** → **USB** → Select your phone (e.g. `SAMSUNG Electronics...` or `SM-S921...`).
3. Unlock your phone screen. You will see a popup: **"Allow USB debugging?"**.
   * Tick **"Always allow from this computer"** and tap **Allow**.

### Step 3: Run the One-Click Installer
In your project directory, run:
```bash
./install-phone.sh
```
This script will:
* Detect your device via ADB.
* Install `android/app/build/outputs/apk/debug/Heaven-Chrome.apk`.
* Automatically launch the game on your phone screen!

---

## 3. Alternative Installation & Testing Methods

### Method 1 — Wireless ADB (No Cable Needed)
1. Ensure your phone and computer are on the same Wi-Fi network.
2. On your phone: **Settings** → **Developer options** → enable **Wireless debugging**.
3. Tap **Wireless debugging** to view your IP and Port (e.g. `192.168.1.50:38521`).
4. Run the installer with your phone's address:
   ```bash
   ./install-phone.sh 192.168.1.50:38521
   ```

### Method 2 — Download via Flask Server (Fastest for Friends/Testers)
1. Start the Flask server:
   ```bash
   ./run-flask.sh
   ```
2. Find your computer's local IP:
   ```bash
   hostname -I | awk '{print $1}'
   ```
3. On your phone's browser (Chrome or Samsung Internet), open:
   `http://<YOUR_IP>:5000/download`
4. Tap **Download** and tap the notification to install `Heaven-Chrome.apk`.

### Method 3 — Transfer APK via File Manager (MTP Cable)
If ADB is not used:
1. Connect your phone via USB and set USB mode on your phone to **"File Transfer / MTP"**.
2. Copy `android/app/build/outputs/apk/debug/Heaven-Chrome.apk` into your phone's **Downloads** folder.
3. Open the **My Files** app on your phone, go to **Downloads**, tap `Heaven-Chrome.apk`, and tap **Install**.
