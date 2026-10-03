#!/usr/bin/env bash
# Root launch script for Heaven Chrome Windows 11 Build
# Automatically uses wine on Linux, and native execution on Windows/MSYS.
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "${SCRIPT_DIR}/windows/run.sh" "$@"
