# Linux Reinstallation Guide: Zero to Hero

This guide walks through setting up the complete **Heaven Chrome** multi-platform development and deployment environment from a completely fresh installation of Debian or Ubuntu.

---

## 1. Automated Setup (One Command)

To configure the entire workstation automatically:
```bash
./tools/setup-linux-from-scratch.sh
```

---

## 2. Step-by-Step Manual Reinstallation

### Step 1: Base Operating System Packages
```bash
sudo apt-get update
sudo apt-get install -y \
  build-essential gcc make git curl wget unzip \
  python3 python3-venv python3-pip \
  perl cpanminus libjson-pp-perl \
  openjdk-21-jdk \
  libsdl2-dev libsdl2-image-dev libsdl2-mixer-dev libsdl2-ttf-dev \
  adb docker.io docker-compose snapd
```

### Step 2: Docker & Permissions
```bash
sudo usermod -aG docker $USER
sudo systemctl enable --now docker
sudo chmod 666 /var/run/docker.sock
```

### Step 3: Snap Tools
```bash
sudo snap install helm --classic
sudo snap install scrcpy
```

### Step 4: Local Kubernetes Cluster (Kind)
```bash
# Install Kind
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.27.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

# Create Cluster
kind create cluster --name heaven-chrome
kind export kubeconfig --name heaven-chrome
```

### Step 5: Istio Service Mesh
Using the pre-packaged `bin/istioctl`:
```bash
./bin/istioctl install --set profile=demo -y
kubectl label namespace default istio-injection=enabled --overwrite
```

### Step 6: ArgoCD GitOps & User `theratzul`
```bash
# 1. Install ArgoCD
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v3.5.3/manifests/install.yaml

# 2. Configure user theratzul
kubectl -n argocd patch cm argocd-cm --type merge -p '{"data":{"accounts.theratzul":"apiKey, login"}}'
kubectl -n argocd patch cm argocd-rbac-cm --type merge -p '{"data":{"policy.csv":"g, theratzul, role:admin\n"}}'

# 3. Retrieve admin password & set password for theratzul
ADMIN_PWD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
./bin/argocd account update-password \
  --port-forward --port-forward-namespace argocd \
  --account theratzul \
  --new-password "HeavenChrome2026!" \
  --current-password "$ADMIN_PWD"
```

### Step 7: System PATH and Aliases
Add to `~/.bashrc`:
```bash
export PATH="/home/vboxuser/myrepos/Heaven-Chrome/bin:$PATH"
alias argocd="argocd --port-forward --port-forward-namespace argocd"
alias argocd-login="argocd login --port-forward --port-forward-namespace argocd --username theratzul --password \"HeavenChrome2026!\" --insecure"
```

---

## 3. Verification Checklist

Run each verification command:
```bash
# 1. Check ArgoCD & applications
./tools/argocd-connect.sh

# 2. Check Istio mesh health
./tools/istioctl-check.sh

# 3. Test Perl server
./run-perl.sh & curl -s http://localhost:5050/api/status

# 4. Test Python Flask server
./run-flask.sh & curl -s http://localhost:5000/api/status

# 5. Check CLI tool versions
istioctl version
argocd version --client
kpt version
yq --version
jq --version
agy --version
gemini --version
```
