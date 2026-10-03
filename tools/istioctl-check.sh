#!/usr/bin/env bash
# ==============================================================================
# Istio Service Mesh Health & Diagnostics Script
# ==============================================================================
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

export PATH="$REPO_ROOT/bin:$PATH"

echo "=========================================================="
echo " 1. Istio Version & Client/Control Plane Status:"
echo "=========================================================="
istioctl version

echo ""
echo "=========================================================="
echo " 2. Istio Configuration Analysis (istioctl analyze):"
echo "=========================================================="
istioctl analyze || true

echo ""
echo "=========================================================="
echo " 3. Envoy Proxy Synchronization Status (istioctl proxy-status):"
echo "=========================================================="
istioctl proxy-status || true

echo ""
echo "=========================================================="
echo " 4. Istio Control Plane & Gateway Pods:"
echo "=========================================================="
kubectl get pods -n istio-system -o wide || true

echo ""
echo "=========================================================="
echo " 5. Deployed Gateways & VirtualServices:"
echo "=========================================================="
kubectl get gateway,virtualservice -A || true

echo ""
echo "=========================================================="
echo " Tip: To inspect proxy routes on a specific pod, run:"
echo "   POD=\$(kubectl get pod -l app.kubernetes.io/name=heaven-chrome-kpt -o jsonpath='{.items[0].metadata.name}')"
echo "   istioctl proxy-config routes \$POD"
echo "=========================================================="
