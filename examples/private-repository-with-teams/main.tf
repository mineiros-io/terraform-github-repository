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
  topics             = ["terrform", "integration-test"]

  teams = [
    {
      id         = module.team.id
      permission = "admin"
    }
  ]

  branch_protection_rules = [
    {
      branch                 = "master"
      enforce_admins         = true
      require_signed_commits = true

      required_status_checks = {
        strict   = true
        contexts = ["ci/travis"]
      }

      required_pull_request_reviews = {
        dismiss_stale_reviews           = true
        dismissal_users                 = ["terraform-test-user-1"]
        dismissal_teams                 = [module.team.slug]
        require_code_owner_reviews      = true
        required_approving_review_count = 1
      }

      restrictions = {
        users = ["terraform-test-user-1"]
        teams = ["team-1"]
      }
    }
  ]

  issue_labels = [
    {
      name = "WIP"
      description = "Work in Progress..."
      color = "d6c860"
    },
    {
      name = "another-label"
      description = "This is a lable created by Terraform..."
      color = "1dc34f"
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
      username = "terraform-test-user-1"
      role     = "member"
    }
  ]
}
