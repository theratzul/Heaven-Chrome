#!/usr/bin/env bash
# ==============================================================================
# Heaven Chrome - Tool Binaries Downloader
# Downloads all official CLI tools (istioctl, argocd, kpt, yq, jq)
# directly from official GitHub releases into the local bin/ folder.
# ==============================================================================
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
BIN_DIR="$REPO_ROOT/bin"

mkdir -p "$BIN_DIR"

echo "=========================================================="
echo " Downloading Tool Binaries into: $BIN_DIR"
echo "=========================================================="

ARCH="$(uname -m)"
if [ "$ARCH" = "x86_64" ]; then
    ARCH_SUFFIX="amd64"
    YQ_ARCH="linux_amd64"
elif [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
    ARCH_SUFFIX="arm64"
    YQ_ARCH="linux_arm64"
else
    echo "[-] Unsupported architecture: $ARCH"
    exit 1
fi

echo ">>> [1/5] Downloading istioctl (1.31.1)..."
curl -sSL "https://github.com/istio/istio/releases/download/1.31.1/istioctl-1.31.1-linux-$ARCH_SUFFIX.tar.gz" -o /tmp/istioctl.tar.gz
tar -xzf /tmp/istioctl.tar.gz -C "$BIN_DIR" istioctl
rm -f /tmp/istioctl.tar.gz
chmod +x "$BIN_DIR/istioctl"
echo "    [✓] istioctl installed."

echo ">>> [2/5] Downloading argocd CLI (v3.5.3)..."
curl -sSL "https://github.com/argoproj/argo-cd/releases/download/v3.5.3/argocd-linux-$ARCH_SUFFIX" -o "$BIN_DIR/argocd"
chmod +x "$BIN_DIR/argocd"
echo "    [✓] argocd installed."

echo ">>> [3/5] Downloading kpt (v1.0.0-beta.61)..."
curl -sSL "https://github.com/GoogleContainerTools/kpt/releases/download/v1.0.0-beta.61/kpt_linux_$ARCH_SUFFIX" -o "$BIN_DIR/kpt"
chmod +x "$BIN_DIR/kpt"
echo "    [✓] kpt installed."

echo ">>> [4/5] Downloading yq (v4.54.1)..."
curl -sSL "https://github.com/mikefarah/yq/releases/download/v4.54.1/yq_$YQ_ARCH" -o "$BIN_DIR/yq"
chmod +x "$BIN_DIR/yq"
echo "    [✓] yq installed."

echo ">>> [5/5] Downloading jq (1.7.1)..."
curl -sSL "https://github.com/jqlang/jq/releases/download/jq-1.7.1/jq-linux-$ARCH_SUFFIX" -o "$BIN_DIR/jq"
chmod +x "$BIN_DIR/jq"
echo "    [✓] jq installed."

if command -v agy >/dev/null 2>&1; then
    cp "$(command -v agy)" "$BIN_DIR/agy" 2>/dev/null || true
fi
if command -v gemini >/dev/null 2>&1; then
    cp "$(command -v gemini)" "$BIN_DIR/gemini" 2>/dev/null || true
fi

if [ "$1" = "--system" ]; then
    echo ">>> Installing binaries into /usr/local/bin/..."
    sudo cp "$BIN_DIR"/* /usr/local/bin/
    echo "    [✓] Binaries copied to /usr/local/bin."
fi

echo ""
echo "=========================================================="
echo " [✓] All tools downloaded successfully into $BIN_DIR!"
echo "=========================================================="
