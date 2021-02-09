# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CREATE A REPOSITORY WITH A SECRET
# This example will create a repository with a secret and some basic settings.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ---------------------------------------------------------------------------------------------------------------------
# TEST
# We are creating a repository with a single secret while specifying only the minimum required variables
# ---------------------------------------------------------------------------------------------------------------------

module "repository" {
  source = "../.."

  name = var.name

  plaintext_secrets = {
    (var.secret_name) = var.secret_text
  }
}
