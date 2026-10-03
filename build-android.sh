#!/bin/bash
set -e

# ============================================
#  Heaven Chrome - Android Build Script
# ============================================

REPO_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$REPO_ROOT"

export ANDROID_HOME="${ANDROID_HOME:-$HOME/android-sdk}"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools"

echo "1. Syncing Web Assets with Capacitor..."
npx cap sync android

echo "2. Building F-Droid Release & Debug APKs..."
cd "$REPO_ROOT/android"
./gradlew assembleRelease assembleDebug --no-daemon

echo ""
echo "=== Android Build Successful (F-Droid Ready) ==="
echo "Generated Release APK (F-Droid & Direct Install):"
ls -lh "$REPO_ROOT/android/app/build/outputs/apk/release/Heaven-Chrome.apk" 2>/dev/null || true
echo "Generated Debug APK:"
ls -lh "$REPO_ROOT/android/app/build/outputs/apk/debug/Heaven-Chrome.apk" 2>/dev/null || true
