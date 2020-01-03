resource "github_team" "team" {
  name           = var.name
  description    = var.description
  privacy        = var.privacy
  parent_team_id = var.parent_team_id
  ldap_dn        = var.ldap_dn
}

resource "github_team_membership" "team_membership" {
  count = length(var.members)

  team_id  = github_team.team.id
  username = var.members[count.index].username
  role     = var.members[count.index].role
}
