#!/usr/bin/env bash
# ==============================================================================
# Android Emulator & Device Runner for Heaven Chrome
# Starts an Android Emulator (or detects connected device),
# installs the latest Heaven-Chrome APK, launches it, and mirrors with scrcpy.
# ==============================================================================
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

export ANDROID_HOME="${ANDROID_HOME:-/home/vboxuser/android-sdk}"
export PATH="$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"

APK_RELEASE="$REPO_ROOT/android/app/build/outputs/apk/release/Heaven-Chrome.apk"
APK_DEBUG="$REPO_ROOT/android/app/build/outputs/apk/debug/Heaven-Chrome.apk"
PKG_NAME="com.popabogdan.heavenchronos"

echo "=========================================================="
echo " HEAVEN CHROME - ANDROID EMULATOR & TEST RUNNER"
echo "=========================================================="
echo " [i] ANDROID_HOME : $ANDROID_HOME"
echo " [i] Package Name : $PKG_NAME"

# Check if an ADB device or emulator is already connected
ONLINE_DEVICES=$(adb devices 2>/dev/null | grep -v "List" | grep "device$" | awk '{print $1}' || true)

if [ -n "$ONLINE_DEVICES" ]; then
    echo " [+] Active Android device/emulator detected: $ONLINE_DEVICES"
else
    echo " [!] No online Android device found via ADB."
    echo " [*] Checking for local Android Virtual Devices (AVD)..."

    AVD_LIST=$(emulator -list-avds 2>/dev/null || true)

    if [ -n "$AVD_LIST" ]; then
        FIRST_AVD=$(echo "$AVD_LIST" | head -n 1)
        echo " [+] Found AVD: $FIRST_AVD"
        echo " [*] Booting AVD '$FIRST_AVD' in background..."
        
        # Check KVM acceleration support
        EMU_FLAGS="-gpu swiftshader_indirect -no-snapshot"
        if [ ! -e /dev/kvm ]; then
            echo " [!] /dev/kvm not found (VM environment). Using software emulation mode (-no-accel)..."
            EMU_FLAGS="$EMU_FLAGS -no-accel"
        fi

        nohup emulator -avd "$FIRST_AVD" $EMU_FLAGS > /tmp/emulator.log 2>&1 &
        echo " [*] Waiting for emulator to boot up (adb wait-for-device)..."
        adb wait-for-device
    else
        echo " [i] No AVD created yet."
        echo ""
        echo " Options for testing Android APK:"
        echo " 1) Physical phone via USB: Enable USB debugging and plug cable in."
        echo "    (If inside VirtualBox: VirtualBox menu -> Devices -> USB -> select your phone)"
        echo " 2) Wireless phone test: Connect phone to same Wi-Fi, then run:"
        echo "    ./install-phone.sh <PHONE_IP>:5555"
        echo " 3) Local Web/Flask test: Start local server:"
        echo "    ./run-flask.sh (open http://<PC_IP>:5000/download on phone)"
        echo " 4) Create a new AVD via command-line:"
        echo "    sdkmanager \"system-images;android-34;google_apis;x86_64\""
        echo "    avdmanager create avd -n Pixel_Test -k \"system-images;android-34;google_apis;x86_64\""
        echo ""
    fi
fi

# Re-check online devices
TARGET_DEVICE=$(adb devices 2>/dev/null | grep -v "List" | grep "device$" | awk '{print $1}' | head -n 1 || true)

if [ -n "$TARGET_DEVICE" ]; then
    TARGET_APK="$APK_RELEASE"
    if [ ! -f "$TARGET_APK" ]; then
        TARGET_APK="$APK_DEBUG"
    fi

    if [ -f "$TARGET_APK" ]; then
        echo " [*] Installing APK to $TARGET_DEVICE: $(basename "$TARGET_APK")..."
        adb -s "$TARGET_DEVICE" install -r "$TARGET_APK"

        echo " [*] Launching Heaven Chrome ($PKG_NAME)..."
        adb -s "$TARGET_DEVICE" shell monkey -p "$PKG_NAME" -c android.intent.category.LAUNCHER 1

        if command -v scrcpy >/dev/null 2>&1; then
            echo " [*] Starting scrcpy desktop display mirror..."
            nohup scrcpy -s "$TARGET_DEVICE" --window-title "Heaven Chrome - Android" >/dev/null 2>&1 &
        fi
        echo " [✓] Application launched successfully!"
    else
        echo " [!] APK not found. Please build it first: ./build-android.sh"
    fi
fi
