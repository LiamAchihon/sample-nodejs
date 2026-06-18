terraform {
  backend "s3" {
    bucket       = "devops-k8s-task-tfstate-430658514390"
    key          = "infrastructure/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
