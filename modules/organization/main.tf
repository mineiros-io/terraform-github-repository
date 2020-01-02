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
  projects = { for p in var.projects : lookup(p, "id", lower(p.name)) => merge({
    body = null
  }, p) }
}

resource "github_organization_project" "project" {
  for_each = local.projects

  name = each.value.name
  body = each.value.body
}
