module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.23.0"

  name               = local.cluster_name
  kubernetes_version = var.kubernetes_version

  endpoint_private_access = true
  endpoint_public_access  = true

  enable_cluster_creator_admin_permissions = true
  enable_irsa                              = true

  enabled_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  cloudwatch_log_group_retention_in_days = 30

  addons = {
    coredns = {
      most_recent = true
    }

    kube-proxy = {
      most_recent = true
    }

    vpc-cni = {
      most_recent    = true
      before_compute = true
    }
  }

  vpc_id = module.vpc.vpc_id

  control_plane_subnet_ids = module.vpc.private_subnets
  subnet_ids               = module.vpc.private_subnets

  eks_managed_node_groups = {
    application = {
      name            = "${local.name_prefix}-app"
      use_name_prefix = false

      iam_role_name            = "${local.name_prefix}-node-role"
      iam_role_use_name_prefix = false

      subnet_ids = module.vpc.private_subnets

      ami_type       = "AL2023_x86_64_STANDARD"
      capacity_type  = "ON_DEMAND"
      instance_types = var.node_instance_types

      min_size     = var.node_group_min_size
      desired_size = var.node_group_desired_size
      max_size     = var.node_group_max_size

      disk_size = 30

      labels = {
        environment = var.environment
        role        = "application"
      }

      node_repair_config = {
        enabled = true
      }

      update_config = {
        max_unavailable = 1
      }

      tags = merge(local.common_tags, {
        Name = "${local.name_prefix}-application-nodes"
      })
    }
  }

  tags = local.common_tags
}
