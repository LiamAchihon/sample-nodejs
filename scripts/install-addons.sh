#!/usr/bin/env bash

set -euo pipefail

ENVIRONMENT="${1:?Usage: $0 <dev|stage|prod>}"

case "$ENVIRONMENT" in
  dev|stage|prod)
    ;;
  *)
    echo "Environment must be dev, stage, or prod"
    exit 1
    ;;
esac

TERRAFORM_DIR="terraform/environments/${ENVIRONMENT}"
VPC_ID="$(terraform -chdir="${TERRAFORM_DIR}" output -raw vpc_id)"

helm repo add eks https://aws.github.io/eks-charts --force-update
helm repo add autoscaler https://kubernetes.github.io/autoscaler --force-update
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server --force-update
helm repo add external-dns https://kubernetes-sigs.github.io/external-dns --force-update
helm repo update

helm upgrade --install aws-load-balancer-controller eks/aws-load-balancer-controller \
  --namespace kube-system \
  --values "helm/addons/aws-load-balancer-controller/values-${ENVIRONMENT}.yaml" \
  --set vpcId="${VPC_ID}" \
  --wait \
  --timeout 10m

kubectl rollout status deployment/aws-load-balancer-controller \
  --namespace kube-system \
  --timeout=5m

helm upgrade --install metrics-server metrics-server/metrics-server \
  --namespace kube-system \
  --values helm/addons/metrics-server/values.yaml \
  --wait \
  --timeout 10m

helm upgrade --install cluster-autoscaler autoscaler/cluster-autoscaler \
  --namespace kube-system \
  --values "helm/addons/cluster-autoscaler/values-${ENVIRONMENT}.yaml" \
  --wait \
  --timeout 10m

helm upgrade --install external-dns external-dns/external-dns \
  --namespace kube-system \
  --values "helm/addons/external-dns/values-${ENVIRONMENT}.yaml" \
  --wait \
  --timeout 10m
