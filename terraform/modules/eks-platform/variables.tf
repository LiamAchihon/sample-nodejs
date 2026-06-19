variable "project_name" {
  description = "Project name used for resource naming"
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

variable "vpc_cidr" {
  description = "CIDR block assigned to the VPC"
  type        = string
}

variable "availability_zones" {
  description = "Availability Zones used by the environment"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks assigned to public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks assigned to private subnets"
  type        = list(string)
}

variable "kubernetes_version" {
  description = "Kubernetes version used by the EKS cluster"
  type        = string
}

variable "node_instance_types" {
  description = "EC2 instance types used by the managed node group"
  type        = list(string)
}

variable "node_group_min_size" {
  description = "Minimum number of worker nodes"
  type        = number
}

variable "node_group_desired_size" {
  description = "Desired number of worker nodes"
  type        = number
}

variable "node_group_max_size" {
  description = "Maximum number of worker nodes"
  type        = number
}

variable "single_nat_gateway" {
  description = "Whether to use one NAT Gateway for the environment"
  type        = bool
  default     = true
}
