terraform {
  required_version = "~> 0.12.9"
}

provider "github" {
  token        = var.github_token
  organization = var.github_organization
}

module "organization" {
  source = "../../modules/organization"

  members = [
    {
      username = "terraform-test-user-1"
    },
    {
      username = "terraform-test-user-2"
      role     = "member"
    }
  ]

  # randomly chosen users, sorry for blocking you guys!
  blocked_users = [
    "Testuser1",
    "Testuser2"
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
