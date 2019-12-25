resource "github_membership" "membership" {
  count = length(var.members)

  username = var.members[count.index].username
  role     = var.members[count.index].role
}

resource "github_organization_block" "blocked_user" {
  count = length(var.blocked_users)

  username = var.blocked_users[count.index]
}
