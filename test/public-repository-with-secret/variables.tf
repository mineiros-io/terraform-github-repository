# ---------------------------------------------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# Define these secrets as environment variables.
# ---------------------------------------------------------------------------------------------------------------------

# GITHUB_ORGANIZATION
# GITHUB_TOKEN

# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# These variables must be set when using this module.
# ---------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# These variables have defaults, but may be overridden.
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  description = "The name of the created repository."
  type        = string
  default     = "test-public-repository-with-secrets"
}

variable "secret_name" {
  description = "Secret name"
  type        = string
  default     = "MYSECRET"
}

variable "secret_text" {
  description = "Secret value in plain text"
  type        = string
  default     = "42"
}
