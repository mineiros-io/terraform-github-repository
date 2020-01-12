terraform {
  required_version = "~> 0.12.9"
}

provider "github" {
  # we want to be compatible with 2.x series of github provider
  version = "~> 2.2"
  # credentials are read from the environment
  # GITHUB_TOKEN
  # GITHUB_ORGANIZATION
}

provider "random" {
  version = "= 2.2.1"
}

provider "tls" {
  version = "= 2.1.1"
}

resource "tls_private_key" "deploy" {
  count = 2

  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "random_pet" "suffix" {
  length = 1
}

module "repository" {
  source = "../.."

  name               = "test-public-repository-complete-example-A-${random_pet.suffix.id}"
  description        = "A public repository created with terraform to test the terraform-github-repository module."
  homepage_url       = "https://github.com/mineiros-io"
  private            = false
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

      required_status_checks = [{
        strict   = true
        contexts = ["ci/travis"]
      }]

      required_pull_request_reviews = [{
        dismiss_stale_reviews           = true
        dismissal_users                 = ["terraform-test-user-1"]
        dismissal_teams                 = [github_team.team.slug]
        require_code_owner_reviews      = true
        required_approving_review_count = 1
      }]

      restrictions = [{
        users = ["terraform-test-user"]
        teams = ["team-1"]
      }]
    }
  ]

  issue_labels = [
    {
      name        = "WIP"
      description = "Work in Progress..."
      color       = "d6c860"
    },
    {
      name        = "another-label"
      description = "This is a lable created by Terraform..."
      color       = "1dc34f"
    }
  ]

  deploy_keys = [
    {
      title     = "CI User Deploy Key"
      key       = tls_private_key.deploy[0].public_key_openssh
      read_only = true
    },
    {
      title     = "Test Key"
      key       = tls_private_key.deploy[1].public_key_openssh
      read_only = false
    }
  ]

  projects = [
    {
      name = "Testproject"
      body = "This is a fancy test project for testing"
    },
    {
      name = "Another Testproject"
      body = "This is a fancy test project for testing"
    }
  ]
}

locals {
  defaults = {
    homepage_url       = "https://github.com/mineiros-io"
    private            = false
    allow_merge_commit = true
    gitignore_template = "Terraform"
    license_template   = "mit"
    topics             = ["terraform", "integration-test"]
  }
}

module "repository-with-defaults" {
  source = "../.."

  name        = "test-public-repository-complete-example-B-${random_pet.suffix.id}"
  description = "A public repository created with terraform to test the terraform-github-repository module."
  defaults    = local.defaults
}

resource "github_team" "team" {
  name        = "test-public-repository-complete-example-${random_pet.suffix.id}"
  description = "A secret team created with terraform to test the terraformn-github-repository module."
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
  username = "terraform-test-user-${count.index + 1}"
  role     = "member"
}

resource "github_team_membership" "team_membership_permanent" {
  team_id  = github_team.team.id
  username = "terraform-test-user"
  role     = "member"
}
