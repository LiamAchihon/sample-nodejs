variable "aws_region" {
  description = "AWS region where the infrastructure will be created"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for resource naming and tags"
  type        = string
  default     = "devops-k8s-task"
}

variable "environment" {
  description = "Environment name used for resource naming and tags"
  type        = string
  default     = "shared"
}

variable "vpc_cidr" {
  description = "CIDR block assigned to the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability Zones used by the VPC"
  type        = list(string)

  default = [
    "us-east-1a",
    "us-east-1b"
  ]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks assigned to the private subnets"
  type        = list(string)

  default = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks assigned to the public subnets"
  type        = list(string)

  default = [
    "10.0.101.0/24",
    "10.0.102.0/24"
  ]
}


variable "kubernetes_version" {
  description = "Kubernetes version used by the EKS cluster"
  type        = string
  default     = "1.35"
}

variable "node_instance_types" {
  description = "EC2 instance types used by the EKS managed node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_group_min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 2
}

variable "node_group_max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 4
}

variable "node_group_desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

