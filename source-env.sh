#!/usr/bin/env bash
# ==============================================================================
# Source Heaven Chrome Repository Environment & Shortcuts
# Usage:
#   source tools/source-repo-bashrc.sh
#   source ./source-env.sh
# ==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/config/bashrc" ]; then
    source "$SCRIPT_DIR/config/bashrc"
elif [ -f "$SCRIPT_DIR/../config/bashrc" ]; then
    source "$SCRIPT_DIR/../config/bashrc"
else
    echo "[-] config/bashrc not found."
fi
