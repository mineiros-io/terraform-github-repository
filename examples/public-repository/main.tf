terraform {
  required_version = "~> 0.12.9"
}

provider "github" {
  version = "~> 2.2"
}

provider "random" {
  version = "= 2.2.1"
}

resource "random_pet" "suffix" {
  length = 1
}

module "repository" {
  source = "../.."

  name               = "test-public-repository-${random_pet.suffix.id}"
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

}
