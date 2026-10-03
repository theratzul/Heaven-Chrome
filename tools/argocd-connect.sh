#!/usr/bin/env bash
# ==============================================================================
# ArgoCD CLI Connection Script - User: theratzul
# ==============================================================================
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

export PATH="$REPO_ROOT/bin:$PATH"

ARGOCD_USER="${ARGOCD_USER:-theratzul}"
ARGOCD_PASS="${ARGOCD_PASS:-HeavenChrome2026!}"
NAMESPACE="${ARGOCD_NAMESPACE:-argocd}"

echo "=========================================================="
echo " Connecting to ArgoCD with user: $ARGOCD_USER"
echo "=========================================================="

argocd login --port-forward --port-forward-namespace "$NAMESPACE" \
  --username "$ARGOCD_USER" \
  --password "$ARGOCD_PASS" \
  --insecure

echo ""
echo "=========================================================="
echo " Currently Deployed Applications in ArgoCD:"
echo "=========================================================="
argocd app list --port-forward --port-forward-namespace "$NAMESPACE"
echo ""
