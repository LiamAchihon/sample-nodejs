#!/usr/bin/env bash

set -euo pipefail

ARGOCD_VERSION="v3.4.4"
NAMESPACE="argocd"
MANIFEST_FILE="/tmp/argocd-${ARGOCD_VERSION}.yaml"

echo "Creating ArgoCD namespace..."

kubectl create namespace "${NAMESPACE}" \
  --dry-run=client \
  -o yaml |
kubectl apply -f -

echo "Downloading ArgoCD ${ARGOCD_VERSION}..."

curl -L --fail --retry 5 \
  -o "${MANIFEST_FILE}" \
  "https://raw.githubusercontent.com/argoproj/argo-cd/${ARGOCD_VERSION}/manifests/install.yaml"

echo "Installing ArgoCD..."

kubectl apply \
  -n "${NAMESPACE}" \
  --server-side \
  --force-conflicts \
  --validate=false \
  --request-timeout=5m \
  -f "${MANIFEST_FILE}"

echo "Waiting for ArgoCD..."

kubectl rollout status deployment/argocd-server \
  -n "${NAMESPACE}" \
  --timeout=5m

kubectl rollout status deployment/argocd-repo-server \
  -n "${NAMESPACE}" \
  --timeout=5m

kubectl rollout status statefulset/argocd-application-controller \
  -n "${NAMESPACE}" \
  --timeout=5m

echo "ArgoCD ${ARGOCD_VERSION} installed successfully."
