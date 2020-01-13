locals {
  homepage_url       = var.homepage_url == null ? lookup(var.defaults, "homepage_url", "") : var.homepage_url
  private            = var.private == null ? lookup(var.defaults, "private", true) : var.private
  has_issues         = var.has_issues == null ? lookup(var.defaults, "has_issues", false) : var.has_issues
  has_projects       = var.has_projects == null ? lookup(var.defaults, "has_projects", false) : length(var.projects) > 0 ? true : var.has_projects
  has_wiki           = var.has_wiki == null ? lookup(var.defaults, "has_wiki", false) : var.has_wiki
  allow_merge_commit = var.allow_merge_commit == null ? lookup(var.defaults, "allow_merge_commit", false) : var.allow_merge_commit
  allow_rebase_merge = var.allow_rebase_merge == null ? lookup(var.defaults, "allow_rebase_merge", false) : var.allow_rebase_merge
  allow_squash_merge = var.allow_squash_merge == null ? lookup(var.defaults, "allow_squash_merge", false) : var.allow_squash_merge
  has_downloads      = var.has_downloads == null ? lookup(var.defaults, "has_downloads", false) : var.has_downloads
  auto_init          = var.auto_init == null ? lookup(var.defaults, "auto_init", true) : var.auto_init
  gitignore_template = var.gitignore_template == null ? lookup(var.defaults, "gitignore_template", "") : var.gitignore_template
  license_template   = var.license_template == null ? lookup(var.defaults, "license_template", "") : var.license_template
  default_branch     = var.default_branch == null ? lookup(var.defaults, "default_branch", "") : var.default_branch
  standard_topics    = var.topics == null ? lookup(var.defaults, "topics", []) : var.topics
  topics             = concat(local.standard_topics, var.extra_topics)
}


locals {
  branch_protection_rules = [
    for b in var.branch_protection_rules : merge({
      branch                        = null
      enforce_admins                = null
      require_signed_commits        = null
      required_status_checks        = {}
      required_pull_request_reviews = {}
      restrictions                  = {}
    }, b)
  ]
}

resource "github_repository" "repository" {
  name               = var.name
  description        = var.description
  homepage_url       = local.homepage_url
  private            = local.private
  has_issues         = local.has_issues
  has_projects       = local.has_projects
  has_wiki           = local.has_wiki
  allow_merge_commit = local.allow_merge_commit
  allow_rebase_merge = local.allow_rebase_merge
  allow_squash_merge = local.allow_squash_merge
  has_downloads      = local.has_downloads
  auto_init          = local.auto_init
  gitignore_template = local.gitignore_template
  license_template   = local.license_template
  default_branch     = local.default_branch
  archived           = var.archived
  topics             = local.topics

  lifecycle {
    ignore_changes = [
      auto_init,
      license_template,
      gitignore_template,
    ]
  }
}

#
# Repository branch protection
#
# https://www.terraform.io/docs/providers/github/r/branch_protection.html
resource "github_branch_protection" "branch_protection_rule" {
  count = length(local.branch_protection_rules)

  # ensure we have all members and collaborators added before applying
  # any configuration for them
  depends_on = [
    github_repository_collaborator.collaborator,
    github_team_repository.team_repository,
  ]

  repository             = github_repository.repository.name
  branch                 = local.branch_protection_rules[count.index].branch
  enforce_admins         = local.branch_protection_rules[count.index].enforce_admins
  require_signed_commits = local.branch_protection_rules[count.index].require_signed_commits

  required_status_checks {
    strict   = lookup(local.branch_protection_rules[count.index].required_status_checks, "strict", null)
    contexts = lookup(local.branch_protection_rules[count.index].required_status_checks, "contexts", [])
  }

  required_pull_request_reviews {
    dismiss_stale_reviews           = lookup(local.branch_protection_rules[count.index].required_pull_request_reviews, "dismiss_stale_reviews", true)
    dismissal_users                 = lookup(local.branch_protection_rules[count.index].required_pull_request_reviews, "dismissal_users", [])
    dismissal_teams                 = lookup(local.branch_protection_rules[count.index].required_pull_request_reviews, "dismissal_teams", [])
    require_code_owner_reviews      = lookup(local.branch_protection_rules[count.index].required_pull_request_reviews, "require_code_owner_reviews", null)
    required_approving_review_count = lookup(local.branch_protection_rules[count.index].required_pull_request_reviews, "required_approving_review_count", null)
  }

  restrictions {
    users = lookup(local.branch_protection_rules[count.index].restrictions, "users", null)
    teams = lookup(local.branch_protection_rules[count.index].restrictions, "teams", null)
  }
}

#
# Repository issue labels
#
locals {
  issue_labels = { for i in var.issue_labels : lookup(i, "id", lower(i.name)) => merge({
    description = null
  }, i) }
}

resource "github_issue_label" "label" {
  for_each = local.issue_labels

  repository  = github_repository.repository.name
  name        = each.value.name
  description = each.value.description
  color       = each.value.color
}

#
# Repository collaborators
#
locals {
  collab_admin = { for i in var.admin_collaborators : i => "admin" }
  collab_push  = { for i in var.push_collaborators : i => "push" }
  collab_pull  = { for i in var.pull_collaborators : i => "pull" }

  collaborators = merge(local.collab_admin, local.collab_push, local.collab_pull)
}

resource "github_repository_collaborator" "collaborator" {
  for_each = local.collaborators

  repository = github_repository.repository.name
  username   = each.key
  permission = each.value
}

#
# Repository teams
#
locals {
  team_admin = [for i in var.admin_team_ids : { team_id = i, permission = "admin" }]
  team_push  = [for i in var.push_team_ids : { team_id = i, permission = "push" }]
  team_pull  = [for i in var.pull_team_ids : { team_id = i, permission = "pull" }]

  teams = concat(local.team_admin, local.team_push, local.team_pull)
}

resource "github_team_repository" "team_repository" {
  count = length(local.teams)

  repository = github_repository.repository.name
  team_id    = local.teams[count.index].team_id
  permission = local.teams[count.index].permission
}

#
# Repository deploy keys
#
locals {
  deploy_keys = [
    for d in var.deploy_keys : merge({
      title     = substr(d.key, 0, 26)
      read_only = true
    }, d)
  ]
}

resource "github_repository_deploy_key" "deploy_key" {
  count = length(local.deploy_keys)

  repository = github_repository.repository.name
  title      = local.deploy_keys[count.index].title
  key        = local.deploy_keys[count.index].key
  read_only  = local.deploy_keys[count.index].read_only
}

#
# Repository projects
#
locals {
  projects = { for i in var.projects : lookup(i, "id", lower(i.name)) => merge({
    body = null
  }, i) }
}

resource "github_repository_project" "repository_project" {
  for_each = local.projects

  repository = github_repository.repository.name
  name       = each.value.name
  body       = each.value.body
}
