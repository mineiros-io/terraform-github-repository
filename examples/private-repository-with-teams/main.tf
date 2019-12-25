terraform {
  required_version = ">= 0.12"
}

provider "github" {
  token        = var.github_token
  organization = var.github_organization
}

module "repository" {
  source = "../../modules/repository"

  name               = "test-repository3"
  description        = "A repository created with terraform to test the terraform-github-repository module."
  homepage_url       = "https://github.com/mineiros-io"
  private            = true
  has_issues         = true
  has_projects       = true
  has_wiki           = true
  allow_merge_commit = true
  allow_rebase_merge = true
  allow_squash_merge = true
  has_downloads      = false
  auto_init          = true
  gitignore_template = "Terraform"
  license_template   = "mit"
  archived           = false
  topics             = ["terrform", "tntegration-test"]

  teams = [
    {
      id         = module.team.id
      permission = "admin"
    }
  ]
}

module "team" {
  source      = "../../modules/team"
  name        = "test-team-1"
  description = "This team is created with terraform to test the terraformn-github-repository module."
  privacy     = "secret"
  members = [
    {
      username = "soerenmartius"
      role     = "member"
    }
  ]
}
