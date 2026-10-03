#!/usr/bin/env bash
set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export PORT="${PORT:-5050}"
export HOST="${HOST:-0.0.0.0}"

echo "=========================================================="
echo " Heaven Chrome - Perl Edition Launcher"
echo " Web UI & Sound Synth : http://localhost:$PORT"
echo " Direct APK Download  : http://localhost:$PORT/download"
echo " Status JSON API      : http://localhost:$PORT/api/status"
echo "=========================================================="

chmod +x "$REPO_ROOT/perl_app/app.pl" "$REPO_ROOT/perl_app/run.sh"
exec "$REPO_ROOT/perl_app/run.sh"
