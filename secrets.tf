# ---------------------------------------------------------------------------------------------------------------------
# Action Secrets
# ---------------------------------------------------------------------------------------------------------------------

locals {
  plaintext_secrets = { for name, value in var.plaintext_secrets : name => { plaintext = value } }
  encrypted_secrets = { for name, value in var.encrypted_secrets : name => { encrypted = value } }

  secrets = merge(local.plaintext_secrets, local.encrypted_secrets)
}

resource "github_actions_secret" "repository_secret" {
  for_each = local.secrets

  repository      = github_repository.repository.name
  secret_name     = each.key
  plaintext_value = try(each.value.plaintext, null)
  encrypted_value = try(each.value.encrypted, null)
}
