# Docker, Kubernetes & ArgoCD Guide for Heaven Chrome

This guide explains how to containerize Heaven Chrome, deploy it to a local Kubernetes cluster using Helm, and manage it via GitOps with ArgoCD.

---

## 1. Docker Setup

Heaven Chrome's web application is packaged using a production-optimized `nginx:alpine` container.

### Docker Storage on /mnt/storage
To prevent Docker images, build caches, and layers from filling the root partition (`/`), Docker is configured with its data root on the secondary LVM partition (`/mnt/storage/docker`).

Configuration file: `/etc/docker/daemon.json`
```json
{
  "data-root": "/mnt/storage/docker"
}
```

To verify Docker's root directory:
```bash
sudo docker info --format 'Docker Root Dir: {{.DockerRootDir}}'
```
Expected output: `Docker Root Dir: /mnt/storage/docker`

### Building the Docker Image
```bash
docker build -t heaven-chrome:latest -t heaven-chrome:1.0.0 .
```

### Running with Docker
```bash
docker run -d --name heaven-chrome-web -p 8080:80 heaven-chrome:latest
```
Visit `http://localhost:8080` in your web browser.

### Running with Docker Compose
```bash
docker compose up -d
```
To stop the container:
```bash
docker compose down
```

---

## 2. Local Kubernetes Cluster (Kind)

The local Kubernetes cluster `heaven-chrome` runs on top of Docker using Kind:

### Checking Cluster Status
```bash
kubectl cluster-info --context kind-heaven-chrome
kubectl get nodes
```

### Loading the Local Docker Image into Kind
When testing local image builds in Kind without pushing to a remote registry:
```bash
kind load docker-image heaven-chrome:latest --name heaven-chrome
```

---

## 3. Helm Chart Deployment

The Helm chart is located in `helm/heaven-chrome/`.

### Structure:
```
helm/heaven-chrome/
├── Chart.yaml              # Chart metadata
├── values.yaml             # Configurable values (replicas, ports, resources)
└── templates/
    ├── deployment.yaml     # Kubernetes Deployment (with probes & security context)
    ├── service.yaml        # Kubernetes Service (ClusterIP / NodePort)
    ├── ingress.yaml        # Ingress resource (optional)
    ├── _helpers.tpl        # Template helpers
    └── NOTES.txt           # Post-install instructions
```

### Installing the Chart
```bash
helm install heaven-chrome ./helm/heaven-chrome --set image.pullPolicy=Never
```

### Upgrading the Release
```bash
helm upgrade heaven-chrome ./helm/heaven-chrome --set image.pullPolicy=Never
```

### Accessing the Web App Locally
Forward the application service to port 8080:
```bash
./k8s/port-forward-app.sh
# or manually:
kubectl port-forward svc/heaven-chrome 8080:80
```
Open [http://localhost:8080](http://localhost:8080) in your browser.

---

## 4. ArgoCD GitOps Deployment

ArgoCD is installed in the `argocd` namespace on the local cluster.

### Accessing the ArgoCD Web UI
Run the helper script:
```bash
./k8s/port-forward-argocd.sh
```
Or manually:
```bash
kubectl port-forward svc/argocd-server -n argocd 8081:443
```
Open **[https://localhost:8081](https://localhost:8081)** (accept the self-signed TLS certificate).

### ArgoCD Credentials
* **Username**: `admin`
* **Password**: Retrieve the cluster secret with:
  ```bash
  kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo ""
  ```

### ArgoCD Application Manifest
The application is pre-configured in `k8s/argocd-app.yaml`:
```bash
kubectl apply -f k8s/argocd-app.yaml
```
ArgoCD will continuously monitor the Git repository and synchronize the Helm chart to the cluster automatically.

---

## 5. Docker Storage Configuration (/mnt/storage)

To avoid exhausting the root partition (`/`), Docker's data directory has been migrated to the secondary LVM partition at `/mnt/storage/docker`.

### Daemon Configuration: `/etc/docker/daemon.json`
```json
{
  "data-root": "/mnt/storage/docker"
}
```

### Verification
```bash
sudo docker info --format 'Docker Root Dir: {{.DockerRootDir}}'
# Expected output: /mnt/storage/docker
```

### Managing Docker & Kubernetes Services
To keep system startup fast and save background resources, autostart on boot is disabled. Use the project helper scripts:
- **Start services**: `./start-k8s-docker.sh`
- **Stop services**: `./stop-k8s-docker.sh`
