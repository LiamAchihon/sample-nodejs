variable "aws_region" {
  description = "AWS region for the production environment"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "devops-k8s-task"
}

variable "kubernetes_version" {
  description = "Kubernetes version for the production EKS cluster"
  type        = string
  default     = "1.35"
}
