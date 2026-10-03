#!/usr/bin/env bash
# Manually start Docker & Kubernetes for this session only.
# Autostart on boot stays DISABLED (see stop-k8s-docker.sh).
set -euo pipefail

echo "=================================================="
echo " Starting Docker & Kubernetes Services (Manual)"
echo " Note: Autostart on boot remains DISABLED"
echo "=================================================="

SERVICES=(
    containerd.service
    docker.socket
    docker.service
    kubelet.service
)

for svc in "${SERVICES[@]}"; do
    echo "Starting ${svc}..."
    sudo systemctl start "${svc}" || echo "  WARNING: failed to start ${svc}"
done

echo ""
echo "Current status:"
for svc in "${SERVICES[@]}"; do
    printf "  %-22s %s\n" "${svc}" "$(systemctl is-active "${svc}" 2>/dev/null || true)"
done
echo "=================================================="
echo " Services started for this session only."
echo "=================================================="
