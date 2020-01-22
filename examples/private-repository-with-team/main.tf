terraform {
  required_version = "~> 0.12.9"
}

provider "github" {
  version = "~> 2.3"
}

module "repository" {
  source = "../.."

  name               = "private-repository-with-teams"
  description        = "A private repository created with terraform to test the terraform-github-repository module."
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
  topics             = ["terraform", "integration-test"]

  admin_team_ids = [
    github_team.team.id
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
        dismissal_teams                 = [github_team.team.slug]
        require_code_owner_reviews      = true
        required_approving_review_count = 1
      }

      restrictions = {
        users = ["terraform-test-user-1"]
        teams = ["team-1"]
      }
    }
  ]
}

resource "github_team" "team" {
  name        = "private-repository-with-teams-test-team"
  description = "This team is created with terraform to test the terraformn-github-repository module."
  privacy     = "secret"
}

# ---------------------------------------------------------------------------------------------------------------------
# TEAM MEMBERSHIP
# We are adding two members to this team. terraform-test-user-1 and terraform-test-user-2 which are both existing users
# and already members of the GitHub Organization terraform-test that is an Organization managed by Mineiros.io to run
# integration tests with Terragrunt.
# ---------------------------------------------------------------------------------------------------------------------

resource "github_team_membership" "team_membership" {
  count = 2

  team_id  = github_team.team.id
  username = "terraform-test-user-${count.index}"
  role     = "member"
}
