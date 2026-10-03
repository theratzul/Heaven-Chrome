#!/usr/bin/env bash
# Port-forward Heaven Chrome service to localhost:8080
echo "Starting Heaven Chrome Web on http://localhost:8080"
kubectl port-forward svc/heaven-chrome 8080:80
