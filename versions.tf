# ---------------------------------------------------------------------------------------------------------------------
# SET TERRAFORM AND PROVIDER REQUIREMENTS FOR RUNNING THIS MODULE
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = "~> 1.0"

  # 4.7.0 to 4.9.1 has a security regression: new repositories created via a
  # template have a public visibility. Has been fixed in 4.9.2.
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 4.20"
    }
  }
}
