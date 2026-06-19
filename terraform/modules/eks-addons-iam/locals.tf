locals {
  name_prefix = "${var.project_name}-${var.environment}"

  load_balancer_controller_role_name = "${local.name_prefix}-aws-lbc"
  external_dns_role_name             = "${local.name_prefix}-external-dns"
  cluster_autoscaler_role_name       = "${local.name_prefix}-cluster-autoscaler"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = "Liam"
  }
}