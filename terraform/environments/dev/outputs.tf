output "vpc_id" {
  description = "Dev VPC ID"
  value       = module.eks_platform.vpc_id
}

output "public_subnet_ids" {
  description = "Dev public subnet IDs"
  value       = module.eks_platform.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Dev private subnet IDs"
  value       = module.eks_platform.private_subnet_ids
}

output "cluster_name" {
  description = "Dev EKS cluster name"
  value       = module.eks_platform.cluster_name
}

output "cluster_endpoint" {
  description = "Dev EKS cluster endpoint"
  value       = module.eks_platform.cluster_endpoint
}

output "oidc_provider_arn" {
  description = "Dev EKS OIDC provider ARN"
  value       = module.eks_platform.oidc_provider_arn
}


output "load_balancer_controller_role_arn" {
  description = "IAM role ARN for AWS Load Balancer Controller"
  value       = module.eks_addons_iam.load_balancer_controller_role_arn
}

output "external_dns_role_arn" {
  description = "IAM role ARN for ExternalDNS"
  value       = module.eks_addons_iam.external_dns_role_arn
}

output "cluster_autoscaler_role_arn" {
  description = "IAM role ARN for Cluster Autoscaler"
  value       = module.eks_addons_iam.cluster_autoscaler_role_arn
}
