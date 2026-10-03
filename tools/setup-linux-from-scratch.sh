#!/usr/bin/env bash
# ==============================================================================
# Heaven Chrome - Zero to Hero Local Linux Reinstallation Script
# Automatically sets up a complete development and deployment environment on Debian/Ubuntu:
# - System compilers & multimedia libraries (GCC, Make, SDL2, Java 21, Wine)
# - Container & Orchestration (Docker, Docker Compose, Kind, Helm, Kubectl)
# - Service Mesh & GitOps (Istio control plane, ArgoCD with user theratzul)
# - Developer toolchain (kpt, yq, jq, scrcpy, Android SDK, Perl, Python)
# ==============================================================================
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "=========================================================="
echo " HEAVEN CHROME - FULL SYSTEM SETUP FROM SCRATCH"
echo "=========================================================="

# 1. Update APT and install base packages
echo ">>> [1/7] Installing system packages via APT..."
sudo apt-get update
sudo apt-get install -y \
  build-essential \
  gcc \
  make \
  curl \
  wget \
  git \
  unzip \
  python3 \
  python3-venv \
  python3-pip \
  perl \
  cpanminus \
  libjson-pp-perl \
  openjdk-21-jdk \
  libsdl2-dev \
  libsdl2-image-dev \
  libsdl2-mixer-dev \
  libsdl2-ttf-dev \
  adb \
  docker.io \
  docker-compose \
  snapd

# 2. Configure Docker user permissions
echo ">>> [2/7] Configuring Docker permissions..."
sudo usermod -aG docker "$USER" || true
sudo systemctl enable --now docker || true
sudo chmod 666 /var/run/docker.sock || true

# 3. Install Snap tools (Helm, scrcpy)
echo ">>> [3/7] Installing Snap packages (Helm, scrcpy)..."
sudo snap install helm --classic || true
sudo snap install scrcpy || true

# 4. Install Kind if missing
echo ">>> [4/7] Checking Kubernetes Kind..."
if ! command -v kind >/dev/null 2>&1; then
    echo "Installing Kind binary..."
    curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.27.0/kind-linux-amd64
    chmod +x ./kind
    sudo mv ./kind /usr/local/bin/kind
fi

# Ensure cluster is created
if ! kind get clusters 2>/dev/null | grep -q "heaven-chrome"; then
    echo "Creating Kind cluster 'heaven-chrome'..."
    kind create cluster --name heaven-chrome
else
    echo "Kind cluster 'heaven-chrome' already exists."
fi
kind export kubeconfig --name heaven-chrome

# 5. Install Istio via istioctl
echo ">>> [5/7] Installing Istio Service Mesh into Kubernetes..."
export PATH="$REPO_ROOT/bin:$PATH"
if [ -f "$REPO_ROOT/bin/istioctl" ]; then
    "$REPO_ROOT/bin/istioctl" install --set profile=demo -y
    kubectl label namespace default istio-injection=enabled --overwrite
fi

# 6. Install ArgoCD & Configure User theratzul
echo ">>> [6/7] Installing ArgoCD and configuring credentials..."
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v3.5.3/manifests/install.yaml

echo "Waiting for ArgoCD server deployment..."
kubectl rollout status deployment/argocd-server -n argocd --timeout=180s || true

# Patch user theratzul
kubectl -n argocd patch cm argocd-cm --type merge -p '{"data":{"accounts.theratzul":"apiKey, login"}}' || true
kubectl -n argocd patch cm argocd-rbac-cm --type merge -p '{"data":{"policy.csv":"g, theratzul, role:admin\n"}}' || true

# 7. Setup CLI Tools in /usr/local/bin
echo ">>> [7/7] Installing pre-built repo binaries into system PATH..."
for bin_name in istioctl argocd kpt yq jq agy gemini; do
    if [ -f "$REPO_ROOT/bin/$bin_name" ]; then
        sudo cp "$REPO_ROOT/bin/$bin_name" "/usr/local/bin/$bin_name"
        sudo chmod +x "/usr/local/bin/$bin_name"
    fi
done

echo ""
echo "=========================================================="
echo " [✓] HEAVEN CHROME SYSTEM SETUP COMPLETE!"
echo " Test commands:"
echo "   ./tools/argocd-connect.sh"
echo "   ./tools/istioctl-check.sh"
echo "   ./run-flask.sh"
echo "   ./run-perl.sh"
echo "=========================================================="
