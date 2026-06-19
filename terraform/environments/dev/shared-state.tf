data "terraform_remote_state" "shared" {
  backend = "s3"

  config = {
    bucket       = "devops-k8s-task-tfstate-430658514390"
    key          = "shared/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}
