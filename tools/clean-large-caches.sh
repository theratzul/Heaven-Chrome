#!/usr/bin/env bash
set -euo pipefail

echo "== Disk space before =="
df -h /

echo "[1/5] Cleaning ~/.gradle/caches..."
rm -rf ~/.gradle/caches

echo "[2/5] Cleaning ~/.vscode-server..."
rm -rf ~/.vscode-server

echo "[3/5] Cleaning ~/.local/share/lutris..."
rm -rf ~/.local/share/lutris

echo "[4/5] Cleaning ~/.wine..."
rm -rf ~/.wine

echo "[5/5] Pruning Docker builder cache..."
if command -v docker >/dev/null 2>&1; then
    sudo systemctl start docker 2>/dev/null || true
    sudo docker builder prune -af || true
fi

echo "== Disk space after =="
df -h /
