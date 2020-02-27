# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CREATE A REPOSITORY WITH COLLABORATORS
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ---------------------------------------------------------------------------------------------------------------------
# SET TERRAFORM AND PROVIDER REQUIREMENTS FOR RUNNING THIS MODULE
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = "~> 0.12.9"
}

provider "github" {
  version = ">= 2.3.1, < 3.0.0"
}

module "repository" {
  source = "../.."

  name                = var.name
  description         = var.description
  homepage_url        = var.url
  private             = false
  has_issues          = var.has_issues
  has_projects        = var.has_projects
  has_wiki            = var.has_wiki
  allow_merge_commit  = var.allow_merge_commit
  allow_rebase_merge  = var.allow_rebase_merge
  allow_squash_merge  = var.allow_squash_merge
  has_downloads       = var.has_downloads
  auto_init           = var.auto_init
  gitignore_template  = var.gitignore_template
  license_template    = var.license_template
  archived            = false
  topics              = var.topics
  admin_collaborators = var.admin_collaborators
}
