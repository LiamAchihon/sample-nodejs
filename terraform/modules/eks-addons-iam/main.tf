module "load_balancer_controller_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
  version = "6.6.1"

  name                                   = local.load_balancer_controller_role_name
  use_name_prefix                        = false
  policy_name                            = "${var.project_name}-${var.environment}-AWS_Load_Balancer_Controller"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    this = {
      provider_arn = var.oidc_provider_arn

      namespace_service_accounts = [
        "${var.load_balancer_controller_namespace}:${var.load_balancer_controller_service_account}"
      ]
    }
  }

  tags = local.common_tags
}

module "external_dns_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
  version = "6.6.1"

  name            = local.external_dns_role_name
  use_name_prefix = false
  policy_name     = "${var.project_name}-${var.environment}-External_DNS"

  attach_external_dns_policy    = true
  external_dns_hosted_zone_arns = [var.route53_zone_arn]

  oidc_providers = {
    this = {
      provider_arn = var.oidc_provider_arn

      namespace_service_accounts = [
        "${var.external_dns_namespace}:${var.external_dns_service_account}"
      ]
    }
  }

  tags = local.common_tags
}

module "cluster_autoscaler_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
  version = "6.6.1"

  name            = local.cluster_autoscaler_role_name
  use_name_prefix = false
  policy_name     = "${var.project_name}-${var.environment}-Cluster_Autoscaler"

  attach_cluster_autoscaler_policy = true
  cluster_autoscaler_cluster_names = [var.cluster_name]

  oidc_providers = {
    this = {
      provider_arn = var.oidc_provider_arn

      namespace_service_accounts = [
        "${var.cluster_autoscaler_namespace}:${var.cluster_autoscaler_service_account}"
      ]
    }
  }

  tags = local.common_tags
}
