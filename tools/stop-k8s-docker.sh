#!/usr/bin/env bash
set -euo pipefail

echo "=================================================="
echo " Stopping & Disabling Docker & Kubernetes Services"
echo "=================================================="

PRIMARY_UNITS=(
    docker.service
    docker.socket
    containerd.service
    kubelet.service
)

OPTIONAL_UNITS=(
    k3s.service
    k3s-agent.service
    microk8s.service
    crio.service
)

echo "[1/2] Stopping running services and sockets..."
for unit in "${PRIMARY_UNITS[@]}"; do
    echo "Stopping ${unit}..."
    sudo systemctl stop "${unit}" 2>/dev/null || true
done

for unit in "${OPTIONAL_UNITS[@]}"; do
    if systemctl list-unit-files "${unit}" 2>/dev/null | grep -q "${unit}"; then
        echo "Stopping optional ${unit}..."
        sudo systemctl stop "${unit}" 2>/dev/null || true
    fi
done

echo "[2/2] Disabling services so Linux starts with them stopped..."
for unit in "${PRIMARY_UNITS[@]}"; do
    echo "Disabling ${unit}..."
    sudo systemctl disable "${unit}" 2>/dev/null || true
done

for unit in "${OPTIONAL_UNITS[@]}"; do
    if systemctl list-unit-files "${unit}" 2>/dev/null | grep -q "${unit}"; then
        echo "Disabling optional ${unit}..."
        sudo systemctl disable "${unit}" 2>/dev/null || true
    fi
done

echo "=================================================="
echo " Services successfully stopped and disabled!"
echo " Linux will now boot without starting them."
echo "=================================================="
