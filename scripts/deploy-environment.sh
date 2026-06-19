#!/usr/bin/env bash

set -euo pipefail

ENVIRONMENT="${1:?Usage: $0 <dev|stage|prod> <image-tag>}"
IMAGE_TAG="${2:?Usage: $0 <dev|stage|prod> <image-tag>}"

case "${ENVIRONMENT}" in
  dev)
    DOMAIN="dev.liamdevops.com"
    ;;
  stage)
    DOMAIN="stage.liamdevops.com"
    ;;
  prod)
    DOMAIN="app.liamdevops.com"
    ;;
  *)
    echo "Environment must be dev, stage, or prod"
    exit 1
    ;;
esac

TERRAFORM_DIR="terraform/environments/${ENVIRONMENT}"
VALUES_FILE="helm/sample-nodejs/values-${ENVIRONMENT}.yaml"
APPLICATION_FILE="argocd/applications/sample-nodejs-${ENVIRONMENT}.yaml"
APPLICATION_NAME="sample-nodejs-${ENVIRONMENT}"
PLAN_FILE="/tmp/${ENVIRONMENT}.tfplan"

echo "=== Terraform: ${ENVIRONMENT} ==="

terraform -chdir="${TERRAFORM_DIR}" init -input=false

terraform -chdir="${TERRAFORM_DIR}" plan \
  -input=false \
  -out="${PLAN_FILE}"

terraform -chdir="${TERRAFORM_DIR}" apply \
  -input=false \
  -auto-approve \
  "${PLAN_FILE}"

CLUSTER_NAME="$(
  terraform -chdir="${TERRAFORM_DIR}" output -raw cluster_name
)"

echo "=== Connecting to ${CLUSTER_NAME} ==="

aws eks update-kubeconfig \
  --region us-east-1 \
  --name "${CLUSTER_NAME}"

kubectl get nodes

echo "=== Installing addons ==="

./scripts/install-addons.sh "${ENVIRONMENT}"

echo "=== Installing ArgoCD ==="

./scripts/install-argocd.sh

echo "=== Updating ${ENVIRONMENT} image tag ==="

git pull --rebase origin main


sed -i \
  "0,/^  tag: .*/s//  tag: ${IMAGE_TAG}/" \
  "${VALUES_FILE}"

git config user.name "github-actions[bot]"
git config user.email "41898282+github-actions[bot]@users.noreply.github.com"

git add "${VALUES_FILE}"

if ! git diff --cached --quiet; then
  git commit \
    -m "chore(cd): deploy ${IMAGE_TAG} to ${ENVIRONMENT} [skip ci]"

  git push origin HEAD:main
fi

echo "=== Applying ArgoCD Application ==="

kubectl apply \
  --validate=false \
  --request-timeout=5m \
  -f "${APPLICATION_FILE}"

kubectl annotate application "${APPLICATION_NAME}" \
  -n argocd \
  argocd.argoproj.io/refresh=hard \
  --overwrite

echo "=== Waiting for ArgoCD ==="

for attempt in {1..60}; do
  SYNC_STATUS="$(
    kubectl get application "${APPLICATION_NAME}" \
      -n argocd \
      -o jsonpath='{.status.sync.status}' \
      2>/dev/null || true
  )"

  HEALTH_STATUS="$(
    kubectl get application "${APPLICATION_NAME}" \
      -n argocd \
      -o jsonpath='{.status.health.status}' \
      2>/dev/null || true
  )"

  echo "Attempt ${attempt}: ${SYNC_STATUS} / ${HEALTH_STATUS}"

  if [ "${SYNC_STATUS}" = "Synced" ] &&
     [ "${HEALTH_STATUS}" = "Healthy" ]; then
    break
  fi

  sleep 10
done

if [ "${SYNC_STATUS}" != "Synced" ] ||
   [ "${HEALTH_STATUS}" != "Healthy" ]; then
  echo "ArgoCD deployment failed."
  exit 1
fi

echo "=== Smoke test: ${DOMAIN} ==="

for attempt in {1..30}; do
  HTTP_STATUS="$(
    curl -sS \
      -o /dev/null \
      -w "%{http_code}" \
      --max-time 10 \
      "https://${DOMAIN}/live" || true
  )"

  echo "Attempt ${attempt}: HTTP ${HTTP_STATUS}"

  if [ "${HTTP_STATUS}" = "200" ]; then
    echo "${ENVIRONMENT} smoke test passed."
    exit 0
  fi

  sleep 10
done

echo "${ENVIRONMENT} smoke test failed."
exit 1
