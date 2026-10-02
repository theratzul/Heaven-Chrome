#!/bin/bash
# ============================================
#  Chronos - Run Script (Linux Wrapper)
# ============================================

# Get the directory where the script is located
CHRONOS_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/"
cd "${CHRONOS_ROOT}"

./build.sh

# Check if build artifact exists (since wine might exit with 0 even if build fails internally in some cmd setups, but we trust the tap file)
if [ -f "build/chronos.tap" ]; then
    echo " Launching in Fuse emulator..."
    
    # Check for system-installed fuse or local fuse
    if command -v fuse >/dev/null 2>&1; then
        fuse --machine 48 --tape "build/chronos.tap" &
    elif [ -f "tools/fuse/fuse" ]; then
        cd "tools/fuse" && ./fuse --machine 48 --tape "../../build/chronos.tap" &
    else
        echo ""
        echo " Native Fuse emulator not found. Attempting to run Windows Fuse via Wine..."
        wine tools/fuse/fuse.exe --machine 48 --tape "build\chronos.tap" &
    fi
fi
