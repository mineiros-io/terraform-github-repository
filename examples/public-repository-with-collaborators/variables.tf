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
  default     = "test-public-repository-with-collaborators"
}

variable "description" {
  description = "The description of the created repository."
  type        = string
  default     = "A public repository created with terraform to test the terraform-github-repository module."
}

variable "url" {
  description = "The url of the created repository."
  type        = string
  default     = "https://github.com/mineiros-io"
}


variable "has_issues" {
  description = "Set to true to enable the GitHub Issues features on the repository."
  type        = bool
  default     = false
}

variable "has_projects" {
  description = "Set to true to enable the GitHub Projects features on the repository."
  type        = bool
  default     = false
}

variable "has_wiki" {
  description = "Set to true to enable the GitHub Wiki features on the repository."
  type        = bool
  default     = false
}

variable "allow_merge_commit" {
  description = "Set to false to disable merge commits on the repository."
  type        = bool
  default     = true
}

variable "allow_squash_merge" {
  description = "Set to true to enable squash merges on the repository."
  type        = bool
  default     = false
}

variable "allow_rebase_merge" {
  description = "Set to true to enable rebase merges on the repository."
  type        = bool
  default     = false
}

variable "has_downloads" {
  description = "Set to true to enable the (deprecated) downloads features on the repository."
  type        = bool
  default     = false
}

variable "auto_init" {
  description = "Wether or not to produce an initial commit in the repository."
  type        = bool
  default     = true
}

variable "gitignore_template" {
  description = "Use the name of the template without the extension. For example, Haskell. Available templates: https://github.com/github/gitignore"
  type        = string
  default     = "Terraform"
}

variable "license_template" {
  description = "Use the name of the template without the extension. For example, 'mit' or 'mpl-2.0'. Available licences: https://github.com/github/choosealicense.com/tree/gh-pages/_licenses"
  type        = string
  default     = "mit"
}

variable "topics" {
  description = "The list of topics of the repository."
  type        = list(string)
  default     = ["terraform", "integration-test"]
}

variable "admin_collaborators" {
  description = "A list of GitHub usernames that should be added as admin collaborators to the created repository."
  type        = list(string)
  default     = ["terraform-test-user-1"]
}
