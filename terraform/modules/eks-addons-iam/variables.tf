variable "project_name" {
  description = "Project name used for IAM resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string

  validation {
    condition     = contains(["dev", "stage", "prod"], var.environment)
    error_message = "Environment must be dev, stage, or prod."
  }
}

variable "cluster_name" {
  description = "EKS cluster name used by Cluster Autoscaler"
  type        = string
}

variable "oidc_provider_arn" {
  description = "EKS OIDC provider ARN used by IRSA"
  type        = string
}

variable "route53_zone_arn" {
  description = "Route53 hosted zone ARN managed by ExternalDNS"
  type        = string
}

variable "load_balancer_controller_namespace" {
  description = "Kubernetes namespace for AWS Load Balancer Controller"
  type        = string
  default     = "kube-system"
}

variable "load_balancer_controller_service_account" {
  description = "ServiceAccount used by AWS Load Balancer Controller"
  type        = string
  default     = "aws-load-balancer-controller"
}

variable "external_dns_namespace" {
  description = "Kubernetes namespace for ExternalDNS"
  type        = string
  default     = "kube-system"
}

variable "external_dns_service_account" {
  description = "ServiceAccount used by ExternalDNS"
  type        = string
  default     = "external-dns"
}

variable "cluster_autoscaler_namespace" {
  description = "Kubernetes namespace for Cluster Autoscaler"
  type        = string
  default     = "kube-system"
}

variable "cluster_autoscaler_service_account" {
  description = "ServiceAccount used by Cluster Autoscaler"
  type        = string
  default     = "cluster-autoscaler"
}