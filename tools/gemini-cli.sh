#!/usr/bin/env bash
# ==============================================================================
# Gemini CLI Runner
# ==============================================================================
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

export PATH="$REPO_ROOT/bin:$PATH"

if [ $# -eq 0 ]; then
    echo "Usage: ./tools/gemini-cli.sh [args...]"
    echo ""
    echo "Examples:"
    echo "  ./tools/gemini-cli.sh --version"
    echo "  ./tools/gemini-cli.sh --help"
    echo ""
    exit 0
fi

exec "$REPO_ROOT/bin/gemini" "$@"
