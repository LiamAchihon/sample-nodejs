output "load_balancer_controller_role_arn" {
  description = "IAM role ARN for AWS Load Balancer Controller"
  value       = module.load_balancer_controller_irsa.arn
}

output "external_dns_role_arn" {
  description = "IAM role ARN for ExternalDNS"
  value       = module.external_dns_irsa.arn
}

output "cluster_autoscaler_role_arn" {
  description = "IAM role ARN for Cluster Autoscaler"
  value       = module.cluster_autoscaler_irsa.arn
}

output "load_balancer_controller_role_name" {
  description = "IAM role name for AWS Load Balancer Controller"
  value       = module.load_balancer_controller_irsa.name
}

output "external_dns_role_name" {
  description = "IAM role name for ExternalDNS"
  value       = module.external_dns_irsa.name
}

output "cluster_autoscaler_role_name" {
  description = "IAM role name for Cluster Autoscaler"
  value       = module.cluster_autoscaler_irsa.name
}