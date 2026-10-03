#!/bin/bash
set -e

REPO_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
export ANDROID_HOME="${ANDROID_HOME:-$HOME/android-sdk}"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools"

APK_PATH="$REPO_ROOT/android/app/build/outputs/apk/debug/Heaven-Chrome.apk"
PKG_NAME="com.heavenchrome.app"

echo "=== Heaven Chrome Android ADB Tester (No Android Studio Needed) ==="

# Check ADB
if ! command -v adb &> /dev/null; then
    echo "Error: adb not found in $ANDROID_HOME/platform-tools or PATH"
    exit 1
fi

echo "1. Checking connected devices/emulators..."
adb devices -l

DEVICES=$(adb devices | grep -v "List" | grep "device" | awk '{print $1}')
if [ -z "$DEVICES" ]; then
    echo ""
    echo "⚠️  No Android devices or emulators currently detected!"
    echo ""
    echo "Options to connect without Android Studio:"
    echo "  A. USB Connection: Enable 'Developer Options' and 'USB Debugging' on your phone, then plug in USB."
    echo "  B. Wireless ADB:   Connect phone to same Wi-Fi, enable 'Wireless Debugging', and run:"
    echo "                     adb connect <PHONE_IP>:<PORT>"
    echo "  C. Headless Emulator / Anbox / Waydroid: If running Waydroid or local container, adb connects automatically."
    echo ""
    echo "Tip: You can also test the exact same mobile web build locally in browser with mobile viewport:"
    echo "  npm run dev  (or visit http://localhost:8080)"
    exit 0
fi

# Build if APK does not exist
if [ ! -f "$APK_PATH" ]; then
    echo ""
    echo "2. APK not found. Building Debug APK now..."
    "$REPO_ROOT/build-android.sh"
fi

echo ""
echo "3. Installing $APK_PATH on target device..."
adb install -r "$APK_PATH"

echo ""
echo "4. Launching $PKG_NAME..."
adb shell monkey -p "$PKG_NAME" -c android.intent.category.LAUNCHER 1

echo ""
echo "5. Streaming app logs (Press Ctrl+C to stop)..."
adb logcat -v time -s "Capacitor" "HeavenChrome" "Chromium" "Web Console"
