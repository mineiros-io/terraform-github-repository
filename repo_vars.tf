# ---------------------------------------------------------------------------------------------------------------------
# Action Variables
# ---------------------------------------------------------------------------------------------------------------------

locals {
  action_variables = var.variables
}

resource "github_actions_variable" "repository_variable" {
  for_each = local.action_variables

  repository    = github_repository.repository.id
  variable_name = each.key
  value         = each.value
}
