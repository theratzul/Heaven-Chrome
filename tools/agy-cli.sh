#!/usr/bin/env bash
# ==============================================================================
# Antigravity CLI (agy) & Gemini CLI Runner
# ==============================================================================
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Ensure bin is in PATH
export PATH="$REPO_ROOT/bin:$PATH"

echo "=========================================================="
echo " Antigravity & Gemini CLI Suite"
echo "=========================================================="

if [ $# -eq 0 ]; then
    echo "Usage: ./tools/agy-cli.sh [subcommand] [arguments...]"
    echo ""
    echo "Common Commands:"
    echo "  ./tools/agy-cli.sh --version      Display agy version"
    echo "  ./tools/agy-cli.sh --help         Display help options"
    echo "  ./tools/agy-cli.sh status         Show Antigravity status"
    echo "  ./tools/agy-cli.sh chat           Start interactive session"
    echo ""
    exit 0
fi

exec "$REPO_ROOT/bin/agy" "$@"
