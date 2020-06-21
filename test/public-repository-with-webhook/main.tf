# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CREATE A REPOSITORY WITH WEBHOOK
# This example will create a repository with a webhook and some basic settings.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ---------------------------------------------------------------------------------------------------------------------
# SET TERRAFORM AND PROVIDER REQUIREMENTS FOR RUNNING THIS MODULE
# ---------------------------------------------------------------------------------------------------------------------

provider "github" {
  version = "~> 2.6"
}

# ---------------------------------------------------------------------------------------------------------------------
# TEST
# We are creating a repository with a single webhook while specifying only the minimum required variables
# ---------------------------------------------------------------------------------------------------------------------

module "repository" {
  source = "../.."

  name = var.name

  webhooks = [{
    active       = var.webhook_active
    events       = var.webhook_events
    url          = var.webhook_url
    content_type = var.webhook_content_type
    insecure_ssl = var.webhook_insecure_ssl
    secret       = var.webhook_secret
  }]
}
