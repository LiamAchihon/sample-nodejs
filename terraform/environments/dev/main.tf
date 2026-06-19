module "eks_platform" {
  source = "../../modules/eks-platform"

  project_name = var.project_name
  environment  = "dev"

  vpc_cidr = "10.10.0.0/16"

  availability_zones = [
    "us-east-1a",
    "us-east-1b"
  ]

  public_subnet_cidrs = [
    "10.10.101.0/24",
    "10.10.102.0/24"
  ]

  private_subnet_cidrs = [
    "10.10.1.0/24",
    "10.10.2.0/24"
  ]

  kubernetes_version = var.kubernetes_version

  node_instance_types     = ["t3.medium"]
  node_group_min_size     = 1
  node_group_desired_size = 1
  node_group_max_size     = 2

  single_nat_gateway = true
}

module "eks_addons_iam" {
  source = "../../modules/eks-addons-iam"

  project_name = var.project_name
  environment  = "dev"

  cluster_name      = module.eks_platform.cluster_name
  oidc_provider_arn = module.eks_platform.oidc_provider_arn
  route53_zone_arn  = data.terraform_remote_state.shared.outputs.route53_zone_arn
}