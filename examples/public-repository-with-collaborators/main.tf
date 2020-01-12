terraform {
  required_version = "~> 0.12.9"
}

provider "github" {
  version = "~> 2.2"
}

module "repository" {
  source = "../.."

  name               = "public-repository-with-collaborators"
  description        = "A public repository created with terraform to test the terraform-github-repository module."
  homepage_url       = "https://github.com/mineiros-io"
  private            = false
  has_issues         = false
  has_projects       = false
  has_wiki           = false
  allow_merge_commit = false
  allow_rebase_merge = false
  allow_squash_merge = true
  has_downloads      = false
  auto_init          = true
  gitignore_template = "Terraform"
  license_template   = "mit"
  archived           = false
  topics             = ["terraform", "integration-test"]

  admin_collaborators = [
    "terraform-test-user-1"
  ]

}
