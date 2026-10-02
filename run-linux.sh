#!/usr/bin/env bash
# Root launch script for Heaven Chrome Linux
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "${SCRIPT_DIR}/linux/run.sh" "$@"
