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
  type        = string
  description = "The name of the repository."
  default     = "private-test-repository-with-admin-team"
}

variable "description" {
  type        = string
  description = "A description of the repository."
  default     = "A private repository created with terraform to test the terraform-github-repository module."
}

variable "homepage_url" {
  description = "The website of the repository."
  type        = string
  default     = "https://github.com/mineiros-io"
}

variable "has_issues" {
  description = "Set to true to enable the GitHub Issues features on the repository."
  type        = bool
  default     = true
}

variable "has_projects" {
  description = "Set to true to enable the GitHub Projects features on the repository."
  type        = bool
  default     = true
}

variable "has_wiki" {
  description = "Set to true to enable the GitHub Wiki features on the repository."
  type        = bool
  default     = true
}

variable "allow_merge_commit" {
  description = "Set to false to disable merge commits on the repository."
  type        = bool
  default     = true
}

variable "allow_squash_merge" {
  description = "Set to true to enable squash merges on the repository."
  type        = bool
  default     = true
}

variable "allow_rebase_merge" {
  description = "Set to true to enable rebase merges on the repository."
  type        = bool
  default     = true
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

variable "members" {
  description = "A list of members to add to the team."
  type        = list(string)
  default = [
    "terraform-test-user-1",
    "terraform-test-user-2"
  ]
}

variable "team_name" {
  description = "The name of the created team."
  type        = string
  default     = "private-repository-with-teams-test-team"
}

variable "team_description" {
  description = "The description of the created team."
  type        = string
  default     = "This team is created with terraform to test the terraformn-github-repository module."
}
