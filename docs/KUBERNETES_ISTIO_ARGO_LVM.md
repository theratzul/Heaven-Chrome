# Docker, Kubernetes, Istio, ArgoCD & LVM Infrastructure Guide

This guide covers complete local infrastructure setup for **Heaven Chrome**:
1. **LVM Storage Expansion & Root Disk Explanation**
2. **Local Client Binaries (`istioctl`, `argocd`, `docker-compose`, `helm`, `kubectl`)**
3. **Docker & Docker Compose Installation and Usage**
4. **Kubernetes Cluster Setup & Helm Chart**
5. **Istio Service Mesh: Installation, Sidecar Injection, Gateway & VirtualService**
6. **Debugging Istio with `istioctl`**
7. **ArgoCD GitOps: Installation, CLI Login & Application Sync**
8. **Android APK Testing & Distribution**

---

## 1. LVM Storage Expansion & Root Disk Explanation

### 1.1 Current Setup on Debian Host
During setup, a new disk `/dev/sdc` (2.62 GiB) was attached to the Linux system.
- Initialized Physical Volume: `pvcreate /dev/sdc`
- Initialized Volume Group: `vgcreate vg_storage /dev/sdc`
- Initialized Logical Volume: `lvcreate -l 100%FREE -n lv_storage vg_storage`
- Formatted with ext4: `mkfs.ext4 /dev/vg_storage/lv_storage`
- Persistently mounted at `/mnt/storage` in `/etc/fstab`:
  ```text
  /dev/vg_storage/lv_storage /mnt/storage ext4 defaults 0 2
  ```

### 1.2 Why the Disk was not Merged Directly into `/dev/sda1`
On this Debian installation, the root filesystem `/` is a standard MBR partition on `/dev/sda1`, **not an LVM logical volume**.
- Running `pvcreate` on an existing non-LVM root partition (`/dev/sda1`) would destroy the partition table and corrupt the operating system.
- Therefore, the secondary disk `/dev/sdc` was initialized into an LVM Volume Group (`vg_storage`) and mounted at `/mnt/storage`.
- Heavy assets (Docker storage, VM images, build artifacts, Android SDK) can be linked to `/mnt/storage`.

### 1.3 How to Add a New Disk to a True LVM Root (Reference)
If your Linux system uses standard LVM for the root partition (e.g. `/dev/mapper/debian--vg-root` or `/dev/vg_system/root`), use the following sequence:

```bash
# 1. Verify existing physical volumes and volume groups
sudo pvs
sudo vgs
sudo df -h /

# 2. Initialize the new physical disk (e.g. /dev/sdc)
sudo pvcreate /dev/sdc

# 3. Extend the existing root Volume Group (e.g. vg_system)
sudo vgextend vg_system /dev/sdc

# 4. Extend the root Logical Volume and resize the filesystem in one command
sudo lvextend -l +100%FREE -r /dev/vg_system/root
```

---

## 2. Local Client Binaries & Repository Binaries

The repository includes pre-built, verified CLI binaries in `bin/` and installed to `/usr/local/bin/`:

| Binary | Version | Repository Location | System Path | Purpose |
| :--- | :--- | :--- | :--- | :--- |
| **`istioctl`** | 1.31.1 | `bin/istioctl` | `/usr/local/bin/istioctl` | Istio mesh debugging, analysis & installation |
| **`argocd`** | v3.5.3 | `bin/argocd` | `/usr/local/bin/argocd` | ArgoCD GitOps cluster management |
| **`docker`** | 26.1.5 | System | `/usr/bin/docker` | Container runtime & build engine |
| **`docker-compose`** | 2.26.1 | System | `/usr/bin/docker-compose` | Multi-container orchestration |
| **`helm`** | v4.3.0 | Snap | `/snap/bin/helm` | Kubernetes package management |
| **`kubectl`** | v1.32.3 | System | `/usr/bin/kubectl` | Kubernetes cluster control |

### Verifying Versions
```bash
./bin/istioctl version --remote=false
./bin/argocd version --client
docker compose version
helm version
kubectl version --client
```

---

## 3. Local Docker & Docker Compose Setup

### 3.1 Installation on Debian 12 / 13 (Trixie)
```bash
# 1. Install prerequisites and Docker Engine
sudo apt-get update
sudo apt-get install -y docker.io docker-compose

# 2. Add current user to docker group (avoids sudo)
sudo usermod -aG docker $USER
newgrp docker

# 3. Verify Docker daemon is running
sudo systemctl enable --now docker
docker run --rm hello-world
```

### 3.2 Running Heaven Chrome via Docker Compose
From repository root:
```bash
# Build and start in background
docker compose up -d --build

# View logs
docker compose logs -f

# Check status
docker compose ps

# Stop containers
docker compose down
```

---

## 4. Kubernetes Helm Deployment with Istio

The Helm chart in `helm/heaven-chrome/` includes native Istio service mesh resources.

### 4.1 Istio Configuration in `values.yaml`
```yaml
istio:
  enabled: true
  inject: true
  gateway:
    enabled: true
    name: "heaven-chrome-gateway"
    selector:
      istio: ingressgateway
    servers:
      - port:
          number: 80
          name: http
          protocol: HTTP
        hosts:
          - "*"
  virtualService:
    enabled: true
    name: "heaven-chrome-vs"
    hosts:
      - "*"
    gateways:
      - heaven-chrome-gateway
    routes:
      - match:
          - uri:
              prefix: /
        route:
          - destination:
              port:
                number: 80
```

### 4.2 Templates Included:
1. `templates/deployment.yaml`: Injects `sidecar.istio.io/inject: "true"` annotation into pod template.
2. `templates/service.yaml`: ClusterIP service exposing port 80.
3. `templates/gateway.yaml`: `networking.istio.io/v1beta1 Gateway` listening on port 80.
4. `templates/virtualservice.yaml`: `networking.istio.io/v1beta1 VirtualService` routing traffic from Gateway to `heaven-chrome` service.

### 4.3 Testing Manifest Generation
```bash
helm template heaven-chrome ./helm/heaven-chrome
```

---

## 5. Installing & Configuring Istio in the Cluster

### 5.1 Installing Istio via `istioctl`
Using the binary in `bin/istioctl` (or `/usr/local/bin/istioctl`):
```bash
# Install demo profile (includes ingress gateway, istiod control plane)
istioctl install --set profile=demo -y

# Verify Istio control plane pods
kubectl get pods -n istio-system
```

### 5.2 Enabling Sidecar Injection on the Application Namespace
```bash
# Label default namespace for automatic Envoy sidecar injection
kubectl label namespace default istio-injection=enabled --overwrite
```

### 5.3 Deploying Heaven Chrome with Istio Enabled
```bash
helm upgrade --install heaven-chrome ./helm/heaven-chrome \
  --set istio.enabled=true \
  --set istio.inject=true
```

### 5.4 Finding the Istio Ingress Gateway Endpoint
```bash
# For NodePort or LoadBalancer:
export INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].port}')

# Access the app through the Istio Gateway:
curl -I http://$INGRESS_HOST:$INGRESS_PORT/
```

---

## 6. Debugging Istio with `istioctl`

`istioctl` is pre-installed to debug mesh connectivity, proxy configuration, and policy validation:

### 6.1 Analyze Cluster Configuration
Detect misconfigurations, broken routes, or missing gateways:
```bash
istioctl analyze
```

### 6.2 Check Envoy Proxy Synchronization Status
```bash
istioctl proxy-status
```

### 6.3 Inspect Proxy Configurations for a Pod
```bash
# Get pod name
POD=$(kubectl get pod -l app.kubernetes.io/name=heaven-chrome -o jsonpath='{.items[0].metadata.name}')

# View Envoy routes
istioctl proxy-config routes $POD

# View Envoy endpoints
istioctl proxy-config endpoints $POD

# View Envoy clusters
istioctl proxy-config clusters $POD
```

### 6.4 View Istio Sidecar Logs
```bash
kubectl logs $POD -c istio-proxy --tail=100 -f
```

---

## 7. ArgoCD GitOps: Local Setup & CLI Connection

### 7.1 Installing ArgoCD on Kubernetes
```bash
# 1. Create namespace
kubectl create namespace argocd

# 2. Apply official ArgoCD manifests
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v3.5.3/manifests/install.yaml

# 3. Wait for pods to become ready
kubectl wait --for=condition=available deployment/argocd-server -n argocd --timeout=300s
```

### 7.2 Accessing the ArgoCD Web UI
Forward port 8081:
```bash
kubectl port-forward svc/argocd-server -n argocd 8081:443
```
Open **[https://localhost:8081](https://localhost:8081)** (accept self-signed TLS cert).

### 7.3 Retrieving Initial Admin Password
```bash
ARGO_PWD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo "ArgoCD Admin Password: $ARGO_PWD"
```

### 7.4 Logging in via `argocd` CLI
```bash
argocd login localhost:8081 \
  --username admin \
  --password "$ARGO_PWD" \
  --insecure
```

### 7.5 Deploying Heaven-Chrome via ArgoCD
```bash
argocd app create heaven-chrome \
  --repo https://github.com/theratzul/Heaven-Chrome.git \
  --path helm/heaven-chrome \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace default \
  --sync-policy automated

# Sync immediately
argocd app sync heaven-chrome

# Check application status
argocd app get heaven-chrome
```

---

## 8. Android APK Testing & Phone Installation

Both **Release** and **Debug** APKs are built and ready in the repository:
- `android/app/build/outputs/apk/release/Heaven-Chrome.apk` (3.4 MB, signed)
- `android/app/build/outputs/apk/debug/Heaven-Chrome.apk` (4.3 MB, debug)

### Method A: Direct Phone Download via Flask Local Server
Start the local Python server:
```bash
./run-flask.sh
```
On your mobile phone (connected to same Wi-Fi or USB tethering):
1. Navigate to: `http://<YOUR-PC-IP>:5000/download` (or `http://<YOUR-PC-IP>:5000/apk`)
2. Tap download and tap the downloaded APK to install.

### Method B: Automated ADB Cable / Wireless Installation
Run the included installer script:
```bash
# Over USB cable (requires VirtualBox USB passthrough enabled):
./install-phone.sh

# Over Wireless ADB:
./install-phone.sh 192.168.1.50:5555
```

---

## 9. Repository Cleanup

- `node_modules/` has been removed from the local filesystem and untracked from the Git index.
- `.gitignore` ensures `node_modules/` is permanently excluded from git commits.
