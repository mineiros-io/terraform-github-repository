terraform {
  required_version = ">= 0.12"
}

provider "github" {
  token        = var.github_token
  organization = var.github_organization
}

module "organization" {
  source = "../../modules/organization"

  //  members = [
  //    {
  //      username = "soerenmartius"
  //    },
  //    {
  //      username = "mariux"
  //      role     = "admin"
  //    }
  //  ]

  blocked_users = [
    "Ameobea",
    "Testuser1g"
  ]

  projects = [
    {
      name = "Test Project"
      body = "This is a test project created by Terraform"
    },
    {
      name = "Test Project without a body"
    }
  ]
}
