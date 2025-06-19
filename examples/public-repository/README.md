[<img src="https://repository-images.githubusercontent.com/662075696/23600e8a-7d2b-4f5c-aa58-afd28d01f056" width="400"/>][homepage]

[![license][badge-license]][apache20]
[![Terraform Version][badge-terraform]][releases-terraform]

# Create a public repository on Github

## Usage

The code in [main.tf] defines the following code and additional resources to create
a public repository and setting it up with webhooks, team access, collaboration access and
branch protection.

```hcl
module "repository" {
  source  = "amachsoftware/repository/github"
  version = "~> 0.13.0"

  module_depends_on = [
    github_team.team
  ]

  name               = "my-public-repository"
  description        = "A description of the repository."
  homepage_url       = "https://github.com/amachsoftware"
  visibility         = "public"
  has_issues         = true
  has_projects       = false
  has_wiki           = true
  allow_merge_commit = true
  allow_rebase_merge = false
  allow_squash_merge = false
  has_downloads      = false
  auto_init          = true
  gitignore_template = "Terraform"
  license_template   = "mit"
  topics             = ["terraform", "unit-test"]

  admin_team_ids = [
    github_team.team.id
  ]

  webhooks = [
    {
      active       = true
      events       = ["issues"]
      url          = "https://example.com/events"
      content_type = "application/json"
      insecure_ssl = false
      secret       = "sososecret"
    },
  ]

  admin_collaborators = ["terraform-test-user-1"]

  branch_protections = [
    {
      branch                 = "main"
      enforce_admins         = true
      require_signed_commits = true

      required_status_checks = {
        strict   = true
        contexts = ["ci/travis"]
      }

      required_pull_request_reviews = {
        dismiss_stale_reviews           = true
        dismissal_teams                 = [github_team.team.slug]
        require_code_owner_reviews      = true
        required_approving_review_count = 1
      }

      restrictions = {
        teams = [github_team.team.slug]
      }
    }
  ]
}
```

## Running the example

### Cloning the repository

```bash
git clone https://github.com/amachsoftware/terraform-github-repository.git
cd terraform-github-repository/examples/public-respository
```

### Initializing Terraform

Run `terraform init` to initialize the example and download providers and the module.

### Planning the example

Run `terraform plan` to see a plan of the changes.

### Applying the example

Run `terraform apply` to create the resources.
You will see a plan of the changes and Terraform will prompt you for approval to actually apply the changes.

### Destroying the example

Run `terraform destroy` to destroy all resources again.

<!-- References -->

[main.tf]: https://github.com/amachsoftware/terraform-github-repository/blob/main/examples/public-respository/main.tf
[homepage]: https://amach.com
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[badge-terraform]: https://img.shields.io/badge/terraform-1.x%20|0.15%20|0.14%20|%200.13%20|%200.12.20+-623CE4.svg?logo=terraform
[releases-terraform]: https://github.com/hashicorp/terraform/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
