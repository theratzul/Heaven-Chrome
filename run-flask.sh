#!/usr/bin/env bash
# Root launch script for Heaven Chrome Flask Server
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "${SCRIPT_DIR}/flask_app/run.sh" "$@"
