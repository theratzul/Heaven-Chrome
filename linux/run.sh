#!/usr/bin/env bash
# Steam launch wrapper for Heaven Chrome
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${SCRIPT_DIR}"

# Add local directory to LD_LIBRARY_PATH if bundled libs are present
export LD_LIBRARY_PATH="${SCRIPT_DIR}:${LD_LIBRARY_PATH}"

# Launch executable
if [ -f "./bin/heaven-chrome" ]; then
    exec "./bin/heaven-chrome" "$@"
elif [ -f "./heaven-chrome" ]; then
    exec "./heaven-chrome" "$@"
else
    echo "Error: heaven-chrome executable not found in ${SCRIPT_DIR}"
    exit 1
fi
