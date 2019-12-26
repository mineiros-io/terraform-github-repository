terraform {
  required_version = ">= 0.12"
}

provider "github" {
  token        = var.github_token
  organization = var.github_organization
}

module "organization" {
  source = "../../modules/organization"

  members = [
    {
      username = "soerenmartius"
      #role     = ""
      # won't work when role isn't set explicitly
    }
  ]

  blocked_users = [
    "terraform-test-user-1"
  ]
}
