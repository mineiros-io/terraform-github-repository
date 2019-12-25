terraform {
  required_version = ">= 0.12"
}

provider "github" {
  token        = var.github_token
  organization = var.github_organization
}

module "blocked_users" {
  source = "../../modules/organization"

  blocked_users = [
    "soerenmartius",
    "terraform-test-user-1"
  ]
}
