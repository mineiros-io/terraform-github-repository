resource "github_membership" "membership" {
  count = length(var.members)

  username = var.members[count.index].username
  role     = var.members[count.index].role
}
