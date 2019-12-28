locals {
  members = { for i in var.members : lower(i.username) => merge({
    username = null
    role     = "member"
  }, i) }
}

resource "github_membership" "membership" {
  for_each = local.members

  username = each.value.username
  role     = each.value.role
}

resource "github_organization_block" "blocked_user" {
  for_each = var.blocked_users

  username = each.value
}

locals {
  projects = [for p in var.projects : merge({
    id   = lower(p.name)
    body = null
  }, p)]
}

resource "github_organization_project" "project" {
  for_each = { for p in local.projects : p.id => p }

  name = each.value.name
  body = each.value.body
}
