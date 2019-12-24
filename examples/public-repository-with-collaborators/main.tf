terraform {
  required_version = ">= 0.12"
}

provider "github" {
  token        = var.github_token
  organization = var.github_organization
}

module "repository" {
  source = "../../modules/repository"

  name               = "test-repository-2"
  description        = "A repository created with terraform to test the terraform-github-repository module"
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
  topics             = ["terrform", "tntegration-test"]

  collaborators = [
    {
      username   = "soerenmartius"
      permission = "admin"
    }
  ]

}
