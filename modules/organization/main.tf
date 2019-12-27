locals {
  members = [for i in var.members : merge({
    id       = lower(i.username)
    username = null
    role     = "member"
  }, i)]
}

resource "github_membership" "membership" {
  for_each = { for i in local.members : i.id => i }

  username = each.value.username
  role     = each.value.role
}

resource "github_organization_block" "blocked_user" {
  for_each = toset(var.blocked_users)

  username = each.value
}
