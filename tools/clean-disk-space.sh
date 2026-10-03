#!/usr/bin/env bash
# Free disk space on this VM (repo disk /mnt/storage + root disk /).
#
# Default (safe) steps:
#   1. Remove Android build outputs (regenerated on next build, gitignored)
#   2. Repack git objects (git gc), temporarily moving big ignored binaries
#      to /tmp (RAM) so git has scratch space, then moving them back
#   3. apt cache clean, journal vacuum, user caches
#   4. Remove disabled (old) snap revisions
#
# Optional steps (opt-in flags, these delete things you may want):
#   --docker   docker system prune -a --volumes (starts Docker temporarily,
#              then stops it again; boot autostart stays disabled)
#   --bin      delete bin/ binaries (re-download with ./get-tools.sh)
#   --z88dk    delete tools/z88dk (~595 MB)
#   --all      all optional steps
#
# Usage: ./tools/clean-disk-space.sh [--docker] [--bin] [--z88dk] [--all]
set -uo pipefail

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
REPO_DIR="$(cd "$(dirname "${SCRIPT_PATH}")/.." && pwd)"
cd "${REPO_DIR}"

DO_DOCKER=0; DO_BIN=0; DO_Z88DK=0
for arg in "$@"; do
    case "${arg}" in
        --docker) DO_DOCKER=1 ;;
        --bin)    DO_BIN=1 ;;
        --z88dk)  DO_Z88DK=1 ;;
        --all)    DO_DOCKER=1; DO_BIN=1; DO_Z88DK=1 ;;
        -h|--help) sed -n "2,19p" "${SCRIPT_PATH}"; exit 0 ;;
        *) echo "Unknown option: ${arg}"; exit 1 ;;
    esac
done

show_space() { df -h "${REPO_DIR}/." / | awk 'NR==1 || NR>1 {print "  " $0}'; }

echo "== Disk space before =="
show_space

echo ""
echo "[1/4] Removing Android build outputs..."
rm -rf android/app/build android/capacitor-cordova-android-plugins/build \
       android/build android/.gradle

echo "[2/4] Repacking git objects..."
TMP_BIN="/tmp/hc-bin-$$"
MOVED=()
restore_bin() {
    for f in "${MOVED[@]}"; do
        mv "${TMP_BIN}/${f}" "bin/${f}" && echo "  restored bin/${f}"
    done
    MOVED=()
    rmdir "${TMP_BIN}" 2>/dev/null || true
}
trap restore_bin EXIT INT TERM
rm -f .git/objects/pack/tmp_pack_*
mkdir -p "${TMP_BIN}"
for f in argocd agy; do
    if [ -f "bin/${f}" ] && mv "bin/${f}" "${TMP_BIN}/${f}"; then
        MOVED+=("${f}")
    fi
done
git gc --prune=now --quiet || echo "  WARNING: git gc failed (not enough space?)"
rm -f .git/objects/pack/tmp_pack_*
restore_bin
trap - EXIT INT TERM

echo "[3/4] Cleaning apt cache, journal and user caches..."
sudo apt-get clean
sudo journalctl --vacuum-size=50M >/dev/null 2>&1 || true
rm -rf ~/.cache/pip ~/.cache/thumbnails 2>/dev/null || true

echo "[4/4] Removing disabled snap revisions..."
if command -v snap >/dev/null 2>&1; then
    snap list --all 2>/dev/null | awk '/disabled/{print $1, $3}' |
    while read -r name rev; do
        sudo snap remove "${name}" --revision="${rev}"
    done
fi

if [ "${DO_DOCKER}" -eq 1 ]; then
    echo "[opt] Pruning Docker images/containers/volumes..."
    sudo systemctl start containerd docker.socket docker
    sudo docker system prune -a --volumes -f
    sudo systemctl stop docker docker.socket containerd
fi

if [ "${DO_BIN}" -eq 1 ]; then
    echo "[opt] Deleting bin/ binaries (re-download with ./get-tools.sh)..."
    find bin -mindepth 1 -maxdepth 1 -type f -delete
fi

if [ "${DO_Z88DK}" -eq 1 ]; then
    echo "[opt] Deleting tools/z88dk..."
    rm -rf tools/z88dk
fi

echo ""
echo "== Disk space after =="
show_space
