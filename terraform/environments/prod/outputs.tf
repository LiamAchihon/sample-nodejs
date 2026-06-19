output "vpc_id" {
  description = "Production VPC ID"
  value       = module.eks_platform.vpc_id
}

output "public_subnet_ids" {
  description = "Production public subnet IDs"
  value       = module.eks_platform.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Production private subnet IDs"
  value       = module.eks_platform.private_subnet_ids
}

output "cluster_name" {
  description = "Production EKS cluster name"
  value       = module.eks_platform.cluster_name
}

output "cluster_endpoint" {
  description = "Production EKS cluster endpoint"
  value       = module.eks_platform.cluster_endpoint
}

output "oidc_provider_arn" {
  description = "Production EKS OIDC provider ARN"
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
