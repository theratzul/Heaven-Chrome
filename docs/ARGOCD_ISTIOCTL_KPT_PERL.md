# Complete Guide: ArgoCD, istioctl, kpt, yq, jq & Perl Application

This document provides complete instructions and credentials for:
1. **ArgoCD CLI Authentication & Default Admin Password**
2. **ArgoCD User `theratzul` Setup & Permissions**
3. **ArgoCD "App of Apps" Pattern**
4. **Useful `istioctl` Debugging & Inspection Commands**
5. **Tooling in Repo: `kpt`, `yq`, `jq`**
6. **KPT Package Setup & Deployment (`heaven-chrome-kpt`)**
7. **Perl Application Setup, Server & Testing**

---

## 1. ArgoCD CLI Connection & Admin Authentication

ArgoCD is installed in the `argocd` namespace on the local Kubernetes cluster.

### 1.1 Admin Credentials
* **Username:** `admin`
* **Default Admin Password:** `x329-EKVnH8cIFqI`

*(Retrieved from cluster secret `kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`)*

### 1.2 Connecting via `argocd` CLI

Using the binary located at `bin/argocd` (or `/usr/local/bin/argocd`):

#### Method A: Direct CLI Port-Forwarding (Recommended)
No background port-forward process required:
```bash
# Log in as admin
./bin/argocd login --port-forward --port-forward-namespace argocd \
  --username admin \
  --password "x329-EKVnH8cIFqI" \
  --insecure

# List applications
./bin/argocd app list --port-forward --port-forward-namespace argocd
```

#### Method B: Manual Port-Forwarding
```bash
# 1. Forward port 8081 to ArgoCD server
kubectl port-forward svc/argocd-server -n argocd 8081:443 &

# 2. Login via localhost
./bin/argocd login localhost:8081 \
  --username admin \
  --password "x329-EKVnH8cIFqI" \
  --insecure
```

Web UI is available at: **[https://localhost:8081](https://localhost:8081)**

---

## 2. ArgoCD User `theratzul` Setup

A dedicated user account `theratzul` has been created with full administrative privileges.

### 2.1 User Credentials
* **Username:** `theratzul`
* **Password:** `HeavenChrome2026!`
* **Role:** `admin` (full permissions)
* **Capabilities:** `apiKey, login`

### 2.2 How the User Was Created & Configured
1. **Registered in `argocd-cm` ConfigMap:**
   ```bash
   kubectl -n argocd patch cm argocd-cm --type merge -p '{"data":{"accounts.theratzul":"apiKey, login"}}'
   ```
2. **Assigned Admin RBAC in `argocd-rbac-cm` ConfigMap:**
   ```bash
   kubectl -n argocd patch cm argocd-rbac-cm --type merge -p '{"data":{"policy.csv":"g, theratzul, role:admin\n"}}'
   ```
3. **Password Set via CLI:**
   ```bash
   ./bin/argocd account update-password \
     --port-forward --port-forward-namespace argocd \
     --account theratzul \
     --new-password "HeavenChrome2026!" \
     --current-password "x329-EKVnH8cIFqI"
   ```

### 2.3 Logging in as `theratzul`
```bash
./bin/argocd login --port-forward --port-forward-namespace argocd \
  --username theratzul \
  --password "HeavenChrome2026!" \
  --insecure
```

---

## 3. ArgoCD "App of Apps" Pattern

The repository includes a production-grade **App of Apps** pattern under [`k8s/argo-app-of-apps/`](file:///home/vboxuser/myrepos/Heaven-Chrome/k8s/argo-app-of-apps/).

### 3.1 Architecture
```text
k8s/argo-app-of-apps/
├── root-app.yaml                      # Root Application: watches apps/ directory
└── apps/
    ├── heaven-chrome-helm.yaml        # Child App: deploys helm/heaven-chrome
    └── heaven-chrome-kpt.yaml         # Child App: deploys kpt/heaven-chrome-kpt
```

### 3.2 Deploying the App of Apps
```bash
# Apply the root application
kubectl apply -f k8s/argo-app-of-apps/root-app.yaml

# Sync via ArgoCD CLI
./bin/argocd app sync heaven-chrome-app-of-apps --port-forward --port-forward-namespace argocd
```

---

## 4. Useful `istioctl` Commands Reference

The binary [`bin/istioctl`](file:///home/vboxuser/myrepos/Heaven-Chrome/bin/istioctl) (v1.31.1) is installed in the repo and on the system PATH.

### 4.1 Cluster & Mesh Analysis
```bash
# Analyze cluster configuration and detect misconfigurations or missing resources
istioctl analyze

# Analyze a specific namespace
istioctl analyze -n default

# Check mesh installation and version mismatch
istioctl version
```

### 4.2 Envoy Proxy Inspection & Synchronization
```bash
# Check synchronization status of all Envoy sidecars and gateways
istioctl proxy-status

# Get pod name for inspection
POD=$(kubectl get pod -l app.kubernetes.io/name=heaven-chrome-kpt -o jsonpath='{.items[0].metadata.name}')

# View Envoy routes configured on the pod
istioctl proxy-config routes $POD

# View Envoy cluster backends
istioctl proxy-config clusters $POD

# View active Envoy endpoints
istioctl proxy-config endpoints $POD

# View all listeners configured by Istio
istioctl proxy-config listeners $POD
```

### 4.3 Pod Troubleshooting & Logging
```bash
# Describe pod from Istio perspective (checks sidecar injection, services, and virtual services)
istioctl experimental describe pod $POD

# Dynamically adjust Envoy proxy log level to debug
istioctl proxy-config log $POD --level debug

# View sidecar proxy logs in real time
kubectl logs $POD -c istio-proxy -f --tail=100
```

---

## 5. Tooling in Repository: `kpt`, `yq`, `jq`

Pre-compiled, executable binaries are located in [`bin/`](file:///home/vboxuser/myrepos/Heaven-Chrome/bin/) and copied to `/usr/local/bin/`:

| Binary | Version | File Path | Usage Example |
|---|---|---|---|
| **`kpt`** | v1.0.0-beta.61.1 | `bin/kpt` | `./bin/kpt fn render kpt/heaven-chrome-kpt` |
| **`yq`** | v4.54.1 | `bin/yq` | `./bin/yq '.image.tag' helm/heaven-chrome/values.yaml` |
| **`jq`** | 1.7 | `bin/jq` | `curl -s http://localhost:5050/api/status \| ./bin/jq .` |

---

## 6. KPT Package Setup & Deployment (`heaven-chrome-kpt`)

The kpt package is located at [`kpt/heaven-chrome-kpt/`](file:///home/vboxuser/myrepos/Heaven-Chrome/kpt/heaven-chrome-kpt/).

### 6.1 Package Structure
```text
kpt/heaven-chrome-kpt/
├── Kptfile           # Kpt package definition
├── deployment.yaml   # 2-replica Deployment with Istio sidecar injection
├── service.yaml      # ClusterIP Service on port 80
└── istio.yaml        # Istio Gateway & VirtualService routing /kpt
```

### 6.2 Rendering & Applying
```bash
# 1. Render kpt package
./bin/kpt fn render kpt/heaven-chrome-kpt

# 2. Deploy to Kubernetes cluster
kubectl apply -f kpt/heaven-chrome-kpt/deployment.yaml \
              -f kpt/heaven-chrome-kpt/service.yaml \
              -f kpt/heaven-chrome-kpt/istio.yaml

# 3. Verify deployed resources
kubectl get pods,svc,gateway,virtualservice -l app.kubernetes.io/name=heaven-chrome-kpt
```

Status in cluster:
* Pods: `2/2 Running` (application container + Envoy sidecar `istio-proxy`)
* Service: `heaven-chrome-kpt` (ClusterIP: port 80)
* Gateway: `heaven-chrome-kpt-gateway`
* VirtualService: `heaven-chrome-kpt-vs`

---

## 7. Perl Application Setup & Server

A standalone Perl web server has been created in [`perl_app/`](file:///home/vboxuser/myrepos/Heaven-Chrome/perl_app/).

### 7.1 Features
* **Zero CPAN Runtime Requirement:** Uses Perl standard library (`IO::Socket::INET`, `POSIX`, `File::Spec`, `File::Basename`).
* **HTML5 Game & Sound Synth:** Serves all game files from `web/` (`index.html`, `script.js`, `style.css`, MIDI/audio assets).
* **JSON Status API (`/api/status`):** Returns platform, version, and APK status.
* **Direct APK Download (`/download` or `/apk`):** Streams `android/app/build/outputs/apk/release/Heaven-Chrome.apk` directly to mobile devices.

### 7.2 Directory Layout
```text
perl_app/
├── app.pl            # Main Perl HTTP web server
├── cpanfile          # Module dependency declarations
└── run.sh            # Local execution script
run-perl.sh           # Top-level repository runner script
```

### 7.3 Running the Perl Server
```bash
# Launch with one command
./run-perl.sh

# Or with custom port:
PORT=8085 ./run-perl.sh
```

### 7.4 Testing Endpoints
```bash
# Test status API
curl -s http://localhost:5050/api/status | jq .

# Test APK download header
curl -I http://localhost:5050/download

# Open Web Game in browser
xdg-open http://localhost:5050/
```
