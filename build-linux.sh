#!/usr/bin/env bash
# One-click build script for Heaven Chrome Linux & Steam build
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${SCRIPT_DIR}/linux"

echo "=== Building Heaven Chrome Linux (Debian / Steam) ==="
chmod +x run.sh
make clean
make -j$(nproc 2>/dev/null || echo 2)

if [ -f "bin/heaven-chrome" ]; then
    echo ""
    echo "========================================="
    echo "  LINUX BUILD SUCCESSFUL!"
    echo "========================================="
    echo "  Executable: linux/bin/heaven-chrome"
    echo "  Size: $(du -h bin/heaven-chrome | cut -f1)"
    echo "  Launcher:   linux/run.sh"
    echo "========================================="
    echo ""
    echo "To test locally on Linux / Debian:"
    echo "  ./linux/run.sh"
    echo ""
    echo "To package for Steam upload:"
    echo "  make -C linux package"
    echo "  (Produces: linux/heaven-chrome-linux.tar.gz)"
    echo "========================================="
else
    echo "Build failed: binary not generated."
    exit 1
fi
