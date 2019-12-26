locals {
  members = [
    for m in var.members : merge({
      username = null
      role     = "member"
    }, m)
  ]
}

resource "github_membership" "membership" {
  count = length(var.members)

  username = var.members[count.index].username
  role     = length(var.members[count.index].role) > 0 ? var.members[count.index].role : "member"
}

resource "github_organization_block" "blocked_user" {
  count = length(var.blocked_users)

  username = var.blocked_users[count.index]
}
