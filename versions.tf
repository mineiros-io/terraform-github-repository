# ---------------------------------------------------------------------------------------------------------------------
# SET TERRAFORM AND PROVIDER REQUIREMENTS FOR RUNNING THIS MODULE
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = ">= 0.12.20, < 0.16"

  required_providers {
    github = {
      source  = "integrations/github"
      version = ">= 2.9, < 4.0, != 3.1.0"
    }
  }
}
