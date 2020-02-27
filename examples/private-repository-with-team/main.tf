# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CREATE A PRIVATE REPOSITORY WITH AN ATTACHED TEAM
#   - create a private repository
#   - create a team and invite members
#   - add the team to the repository and grant admin permissions
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ---------------------------------------------------------------------------------------------------------------------
# SET TERRAFORM AND PROVIDER REQUIREMENTS FOR RUNNING THIS MODULE
# ---------------------------------------------------------------------------------------------------------------------
terraform {
  required_version = ">= 0.12.9"

  required_providers {
    github = ">= 2.3.1, < 3.0.0"
  }
}


module "repository" {
  source = "../.."

  name               = var.name
  description        = var.description
  homepage_url       = var.homepage_url
  private            = true
  has_issues         = var.has_issues
  has_projects       = var.has_projects
  has_wiki           = var.has_wiki
  allow_merge_commit = var.allow_merge_commit
  allow_rebase_merge = var.allow_rebase_merge
  allow_squash_merge = var.allow_squash_merge
  has_downloads      = var.has_downloads
  auto_init          = var.auto_init
  gitignore_template = "Terraform"
  license_template   = "mit"
  archived           = false
  topics             = ["terraform", "integration-test"]

  admin_team_ids = [
    github_team.team.id
  ]

  branch_protections = [
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
        dismissal_users                 = var.members
        dismissal_teams                 = [github_team.team.slug]
        require_code_owner_reviews      = true
        required_approving_review_count = 1
      }

      restrictions = {
        users = var.members
        teams = [github_team.team.slug]
      }
    }
  ]
}

resource "github_team" "team" {
  name        = var.team_name
  description = var.team_description
  privacy     = "secret"
}

# ---------------------------------------------------------------------------------------------------------------------
# TEAM MEMBERSHIP
# We are adding two members to this team. terraform-test-user-1 and terraform-test-user-2 that we define as default
# members in our variables.tf are both existing users and already members of the GitHub Organization terraform-test that
# is an Organization managed by Mineiros.io to run integration tests with Terratest.
# ---------------------------------------------------------------------------------------------------------------------

resource "github_team_membership" "team_membership" {
  count = length(var.members)

  team_id  = github_team.team.id
  username = var.members[count.index]
  role     = "member"
}
