#!/usr/bin/env bash
# One-click build script for Heaven Chrome Windows 11 & Steam build
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${SCRIPT_DIR}/windows"

echo "=== Building Heaven Chrome for Windows 11 (Steam) ==="
chmod +x run.sh
make clean
make -j$(nproc 2>/dev/null || echo 2)

if [ -f "bin/heaven-chrome.exe" ]; then
    echo ""
    echo "========================================="
    echo "  WINDOWS 11 BUILD SUCCESSFUL!"
    echo "========================================="
    echo "  Executable: windows/bin/heaven-chrome.exe"
    echo "  Size: $(du -h bin/heaven-chrome.exe | cut -f1)"
    echo "  Launcher:   ./run-windows.sh (detects Linux/wine vs Windows)"
    echo "========================================="
    echo ""
    echo "Creating Steam package..."
    make package
    echo ""
    echo "To test:"
    echo "  ./run-windows.sh"
    echo ""
    echo "To add to Steam on Windows 11 or Linux:"
    echo "  1. Extract windows/heaven-chrome-windows.zip (or use windows/bin/)"
    echo "  2. In Steam: Games -> Add a Non-Steam Game to My Library..."
    echo "  3. Select heaven-chrome.exe"
    echo "========================================="
else
    echo "Build failed: binary not generated."
    exit 1
fi
