output "ecr_repository_name" {
  description = "Shared ECR repository name"
  value       = aws_ecr_repository.application.name
}

output "ecr_repository_url" {
  description = "Shared ECR repository URL"
  value       = aws_ecr_repository.application.repository_url
}

output "ecr_kms_key_arn" {
  description = "KMS key ARN used for ECR encryption"
  value       = aws_kms_key.ecr.arn
}

output "route53_zone_id" {
  description = "Route53 hosted zone ID"
  value       = data.aws_route53_zone.main.zone_id
}

output "domain_name" {
  description = "Root domain name"
  value       = var.domain_name
}

output "acm_certificate_arn" {
  description = "ACM wildcard certificate ARN"
  value       = aws_acm_certificate_validation.main.certificate_arn
}

output "environment_domains" {
  description = "Domain names assigned to each environment"
  value       = local.environment_domains
}


output "route53_zone_arn" {
  description = "Route53 hosted zone ARN"
  value       = "arn:aws:route53:::hostedzone/${data.aws_route53_zone.main.zone_id}"
}
