locals {

  branch_protection_rules = [
    for b in var.branch_protection_rules : merge({
      branch                        = null
      enforce_admins                = null
      require_signed_commits        = null
      required_status_checks        = []
      required_pull_request_reviews = []
      restrictions                  = []
    }, b)
  ]

  required_status_checks = [
    for b in local.branch_protection_rules : [
      for r in b.required_status_checks[*] : merge({
        strict   = null
        contexts = []
      }, r)
    ]
  ]

  required_pull_request_reviews = [
    for b in local.branch_protection_rules : [
      for r in b.required_pull_request_reviews[*] : merge({
        dismiss_stale_reviews           = true
        dismissal_users                 = []
        dismissal_teams                 = []
        require_code_owner_reviews      = null
        required_approving_review_count = null
      }, r)
    ]
  ]

  restrictions = [
    for b in local.branch_protection_rules : [
      for r in b.restrictions[*] : merge({
        users = []
        teams = []
      }, r)
    ]
  ]
}

resource "github_repository" "repository" {
  name               = var.name
  description        = var.description
  homepage_url       = var.homepage_url
  private            = var.private
  has_issues         = var.has_issues
  has_projects       = var.has_projects
  has_wiki           = var.has_wiki
  allow_merge_commit = var.allow_merge_commit
  allow_rebase_merge = var.allow_rebase_merge
  allow_squash_merge = var.allow_squash_merge
  has_downloads      = var.has_downloads
  auto_init          = var.auto_init
  gitignore_template = var.gitignore_template
  license_template   = var.license_template
  default_branch     = var.default_branch
  archived           = var.archived
  topics             = var.topics
}

resource "github_branch_protection" "branch_protection_rule" {
  count          = length(local.branch_protection_rules)
  repository     = github_repository.repository.name
  branch         = local.branch_protection_rules[count.index].branch
  enforce_admins = local.branch_protection_rules[count.index].enforce_admins

  dynamic "required_status_checks" {
    for_each = local.required_status_checks[count.index]

    content {
      strict   = required_status_checks.value.strict
      contexts = required_status_checks.value.contexts
    }
  }

  dynamic "required_pull_request_reviews" {
    for_each = local.required_pull_request_reviews[count.index]

    content {
      dismiss_stale_reviews           = required_pull_request_reviews.value.dismiss_stale_reviews
      dismissal_users                 = required_pull_request_reviews.value.dismissal_users
      dismissal_teams                 = required_pull_request_reviews.value.dismissal_teams
      require_code_owner_reviews      = required_pull_request_reviews.value.require_code_owner_reviews
      required_approving_review_count = required_pull_request_reviews.value.required_approving_review_count
    }
  }

  dynamic "restrictions" {
    for_each = local.restrictions[count.index]

    content {
      users = restrictions.value.users
      teams = restrictions.value.teams
    }
  }
}

resource "github_repository_collaborator" "collaborator" {
  count = length(var.collaborators)

  repository = github_repository.repository.name
  username   = var.collaborators[count.index].username
  permission = var.collaborators[count.index].permission
}

resource "github_team_repository" "team_repository" {
  count = length(var.teams)

  repository = github_repository.repository.name
  team_id    = var.teams[count.index].id
  permission = var.teams[count.index].permission
}
