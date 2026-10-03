#!/usr/bin/env bash
# Port-forward ArgoCD Web UI to localhost:8081
echo "Starting ArgoCD UI on https://localhost:8081"
echo "Login: admin"
echo "Password: run 'kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath=\"{.data.password}\" | base64 -d'"
kubectl port-forward svc/argocd-server -n argocd 8081:443
