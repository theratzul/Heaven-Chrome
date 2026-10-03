#!/usr/bin/env bash
# One-click script to install Heaven-Chrome.apk onto connected Android phone
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APK="${SCRIPT_DIR}/android/app/build/outputs/apk/debug/Heaven-Chrome.apk"

if [ ! -f "${APK}" ]; then
    echo "Error: ${APK} not found. Building APK first..."
    "${SCRIPT_DIR}/build-android.sh"
fi

# Check if an IP/port was passed as argument for wireless ADB
if [ -n "$1" ]; then
    echo "Connecting to wireless ADB device at $1..."
    adb connect "$1"
fi

echo "Checking connected Android devices via ADB..."
DEVICES=$(adb devices | grep -v "List of devices" | grep "device$" | awk '{print $1}')

if [ -z "${DEVICES}" ]; then
    echo ""
    echo "================================================================"
    echo "  NO ANDROID DEVICE DETECTED BY ADB IN THIS VIRTUALBOX VM"
    echo "================================================================"
    echo "Your phone is connected to your computer via USB cable, but"
    echo "VirtualBox needs permission to pass the USB connection to this VM."
    echo ""
    echo "Option 1 — Enable VirtualBox USB Passthrough (Instant & Recommended):"
    echo "  1. In the VirtualBox window top menu bar, click: Devices -> USB"
    echo "  2. Click on your phone name (e.g. 'SAMSUNG Electronics...', 'SM-S921...')"
    echo "  3. On your phone screen, accept the prompt: 'Allow USB debugging?'"
    echo "  4. Run this script again: ./install-phone.sh"
    echo ""
    echo "Option 2 — Wireless ADB (Same Wi-Fi Network):"
    echo "  1. On your phone: Settings -> Developer Options -> Wireless debugging (ON)"
    echo "  2. Look at the IP address and port shown (e.g. 192.168.1.50:38521)"
    echo "  3. Run: ./install-phone.sh <IP>:<PORT>"
    echo ""
    echo "Option 3 — Direct Browser Download via Flask Server:"
    echo "  1. Start the Flask server: ./run-flask.sh"
    echo "  2. On your phone browser, open: http://$(hostname -I | awk '{print $1}'):5000/download"
    echo "  3. Tap 'Download' and install the APK directly on your phone!"
    echo "================================================================"
    exit 1
fi

for DEV in ${DEVICES}; do
    echo "--------------------------------------------------------"
    echo "Installing Heaven-Chrome.apk on device: ${DEV}..."
    adb -s "${DEV}" install -r "${APK}"
    echo "Launching Heaven Chrome on device: ${DEV}..."
    adb -s "${DEV}" shell monkey -p com.popabogdan.heavenchronos -c android.intent.category.LAUNCHER 1
    echo "SUCCESS! Heaven Chrome installed and launched on ${DEV}."
    echo "--------------------------------------------------------"
done
