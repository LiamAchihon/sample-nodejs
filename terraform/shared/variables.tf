variable "aws_region" {
  description = "AWS region for shared resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "devops-k8s-task"
}

variable "domain_name" {
  description = "Root domain managed by Route53"
  type        = string
}

variable "ecr_repository_name" {
  description = "Name of the shared ECR repository"
  type        = string
  default     = "sample-nodejs"
}

variable "ecr_max_image_count" {
  description = "Maximum number of tagged images retained in ECR"
  type        = number
  default     = 20
}

variable "ecr_untagged_retention_days" {
  description = "Number of days to retain untagged ECR images"
  type        = number
  default     = 7
}

variable "kms_deletion_window_in_days" {
  description = "Waiting period before permanent KMS key deletion"
  type        = number
  default     = 7

  validation {
    condition = (
      var.kms_deletion_window_in_days >= 7 &&
      var.kms_deletion_window_in_days <= 30
    )

    error_message = "KMS deletion window must be between 7 and 30 days."
  }
}
