#!/bin/bash
# ============================================
#  Chronos - Build Script (Linux Wrapper)
# ============================================

# Get the directory where the script is located
CHRONOS_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/"
cd "${CHRONOS_ROOT}"

# Delegate to the Windows batch script via wine
wine cmd /c build.bat
