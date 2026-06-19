locals {
  name_prefix = "${var.project_name}-shared"

  common_tags = {
    Project   = var.project_name
    ManagedBy = "Terraform"
    Scope     = "Shared"
  }

  environment_domains = {
    dev   = "dev.${var.domain_name}"
    stage = "stage.${var.domain_name}"
    prod  = "app.${var.domain_name}"
  }
}
