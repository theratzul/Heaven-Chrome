#!/usr/bin/env bash
# Steam launch wrapper for Heaven Chrome (Windows Edition)
# Logic: If Linux, starts with wine; if Windows, starts normally.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${SCRIPT_DIR}"

EXE_PATH="./heaven-chrome.exe"
if [ ! -f "$EXE_PATH" ] && [ -f "./bin/heaven-chrome.exe" ]; then
    EXE_PATH="./bin/heaven-chrome.exe"
fi

if [ ! -f "$EXE_PATH" ]; then
    echo "Error: heaven-chrome.exe not found in ${SCRIPT_DIR}"
    exit 1
fi

OS_NAME="$(uname -s 2>/dev/null || echo Windows)"

case "${OS_NAME}" in
    Linux*)
        echo "[Heaven Chrome] Linux host detected. Launching via Wine..."
        if command -v wine >/dev/null 2>&1; then
            exec wine "${EXE_PATH}" "$@"
        else
            echo "Error: Wine is not installed. Please install wine (e.g. sudo apt install wine) to run Windows binaries on Linux."
            exit 1
        fi
        ;;
    CYGWIN*|MINGW*|MSYS*|Windows*)
        echo "[Heaven Chrome] Windows host detected. Launching natively..."
        exec "${EXE_PATH}" "$@"
        ;;
    *)
        if command -v wine >/dev/null 2>&1; then
            exec wine "${EXE_PATH}" "$@"
        else
            exec "${EXE_PATH}" "$@"
        fi
        ;;
esac
