#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export PORT="${PORT:-5050}"
export HOST="${HOST:-0.0.0.0}"

echo "=========================================================="
echo " Starting Heaven Chrome Perl Web Server on port $PORT..."
echo "=========================================================="
exec perl "$SCRIPT_DIR/app.pl"
