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

variable "name" {
  description = "The name of the repository."
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# These variables have defaults, but may be overridden.
# ---------------------------------------------------------------------------------------------------------------------

variable "defaults" {
  description = "Overwrite defaults for various repository settings"
  type        = any

  # Example:
  # defaults = {
  #   homepage_url       = "https://mineiros.io/"
  #   private            = true
  #   has_issues         = false
  #   has_projects       = false
  #   has_wiki           = false
  #   allow_merge_commit = true
  #   allow_rebase_merge = false
  #   allow_squash_merge = false
  #   has_downloads      = false
  #   auto_init          = true
  #   gitignore_template = "terraform"
  #   license_template   = "mit"
  #   default_branch     = "master"
  #   topics             = ["topic-1", "topic-2"]
  # }

  default = {}
}

variable "description" {
  description = "A description of the repository."
  type        = string
  default     = ""
}

variable "homepage_url" {
  description = "The website of the repository."
  type        = string
  default     = null
}

variable "private" {
  description = "Set to false to create a public repository. (Default: true)"
  type        = bool
  default     = null
}

variable "has_issues" {
  description = "Set to true to enable the GitHub Issues features on the repository. (Default: false)"
  type        = bool
  default     = null
}

variable "has_projects" {
  description = "Set to true to enable the GitHub Projects features on the repository. Per the github documentation when in an organization that has disabled repository projects it will default to false and will otherwise default to true. If you specify true when it has been disabled it will return an error.  (Default: false)"
  type        = bool
  default     = null
}

variable "has_wiki" {
  description = "Set to true to enable the GitHub Wiki features on the repository. (Default: false)"
  type        = bool
  default     = null
}

variable "allow_merge_commit" {
  description = "Set to false to disable merge commits on the repository. (Default: true)"
  type        = bool
  default     = null
}

variable "allow_squash_merge" {
  description = "Set to true to enable squash merges on the repository. (Default: false)"
  type        = bool
  default     = null
}

variable "allow_rebase_merge" {
  description = "Set to true to enable rebase merges on the repository. (Default: false)"
  type        = bool
  default     = null
}

variable "has_downloads" {
  description = "Set to true to enable the (deprecated) downloads features on the repository. (Default: false)"
  type        = bool
  default     = null
}

variable "auto_init" {
  description = "Wether or not to produce an initial commit in the repository. (Default: true)"
  type        = bool
  default     = null
}

variable "gitignore_template" {
  description = "Use the name of the template without the extension. For example, Haskell. Available templates: https://github.com/github/gitignore"
  type        = string
  default     = null
}

variable "license_template" {
  description = "Use the name of the template without the extension. For example, 'mit' or 'mpl-2.0'. Available licences: https://github.com/github/choosealicense.com/tree/gh-pages/_licenses"
  type        = string
  default     = null
}

variable "default_branch" {
  description = "The name of the default branch of the repository. NOTE: This can only be set after a repository has already been created, and after a correct reference has been created for the target branch inside the repository. This means a user will have to omit this parameter from the initial repository creation and create the target branch inside of the repository prior to setting this attribute."
  type        = string
  default     = null
}

variable "archived" {
  description = "Specifies if the repository should be archived. (Default: false)"
  type        = bool
  default     = false
}

variable "topics" {
  description = "The list of topics of the repository.  (Default: [])"
  type        = list(string)
  default     = null
}

variable "extra_topics" {
  description = "The list of additional topics of the repository. (Default: [])"
  type        = list(string)
  default     = []
}

variable "template" {
  description = "Template repository to use. (Default: {})"
  type = object({
    owner      = string
    repository = string
  })
  default = null
}

variable "admin_collaborators" {
  description = "A list of users to add as collaborators granting them admin (full) permission."
  type        = list(string)
  default     = []
}

variable "push_collaborators" {
  description = "A list of users to add as collaborators granting them push (read-write) permission."
  type        = list(string)
  default     = []
}

variable "pull_collaborators" {
  description = "A list of users to add as collaborators granting them pull (read-only) permission."
  type        = list(string)
  default     = []
}

variable "triage_collaborators" {
  description = "A list of users to add as collaborators granting them triage permission."
  type        = list(string)
  default     = []
}

variable "maintain_collaborators" {
  description = "A list of users to add as collaborators granting them maintain permission."
  type        = list(string)
  default     = []
}

variable "admin_team_ids" {
  description = "A list of teams (by id) to grant admin (full) permission to."
  type        = list(string)
  default     = []
}

variable "push_team_ids" {
  description = "A list of teams (by id) to grant push (read-write) permission to."
  type        = list(string)
  default     = []
}

variable "pull_team_ids" {
  description = "A list of teams (by id) to grant pull (read-only) permission to."
  type        = list(string)
  default     = []
}

variable "triage_team_ids" {
  description = "A list of teams (by id) to grant triage permission to."
  type        = list(string)
  default     = []
}

variable "maintain_team_ids" {
  description = "A list of teams (by id) to grant maintain permission to."
  type        = list(string)
  default     = []
}

variable "branch_protections" {
  description = "Configuring protected branches. For details please check: https://www.terraform.io/docs/providers/github/r/branch_protection.html"
  type        = any

  # We can't use a detailed type specification due to a terraform limitation. However, this might be changed in a future
  # Terraform version. See https://github.com/hashicorp/terraform/issues/19898 and https://github.com/hashicorp/terraform/issues/22449
  #
  # type = list(object({
  #   branch                 = string
  #   enforce_admins         = bool
  #   require_signed_commits = bool
  #   required_status_checks = object({
  #     strict   = bool
  #     contexts = list(string)
  #   })
  #   required_pull_request_reviews = object({
  #     dismiss_stale_reviews           = bool
  #     dismissal_users                 = list(string)
  #     dismissal_teams                 = list(string)
  #     require_code_owner_reviews      = bool
  #     required_approving_review_count = number
  #   })
  #   restrictions = object({
  #     users = list(string)
  #     teams = list(string)
  #   })
  # }))

  default = []

  # Example:
  # branch_protections = [
  #   {
  #     branch                 = "master"
  #     enforce_admins         = true
  #     require_signed_commits = true
  #
  #     required_status_checks = {
  #       strict   = false
  #       contexts = ["ci/travis"]
  #     }
  #
  #     required_pull_request_reviews = {
  #       dismiss_stale_reviews           = true
  #       dismissal_users                 = ["user1", "user2"]
  #       dismissal_teams                 = ["team-slug-1", "team-slug-2"]
  #       require_code_owner_reviews      = true
  #       required_approving_review_count = 1
  #     }
  #
  #     restrictions = {
  #       users = ["user1"]
  #       teams = ["team-slug-1"]
  #     }
  #   }
  # ]
}

variable "issue_labels_merge_with_github_labels" {
  description = "Specify if you want to merge and control githubs default set of issue labels."
  type        = bool
  default     = null
}

variable "issue_labels" {
  description = "Configure a GitHub issue label resource."
  type = list(object({
    name        = string
    description = string
    color       = string
  }))

  # Example:
  # issue_labels = [
  #   {
  #     name        = "WIP"
  #     description = "Work in Progress..."
  #     color       = "d6c860"
  #   },
  #   {
  #     name        = "another-label"
  #     description = "This is a lable created by Terraform..."
  #     color       = "1dc34f"
  #   }
  # ]

  default = []
}

variable "deploy_keys" {
  description = "Configure a deploy key ( SSH key ) that grants access to a single GitHub repository. This key is attached directly to the repository instead of to a personal user account."
  type        = any

  # Example:
  # deploy_keys = [
  #   {
  #     title     = "CI User Deploy Key"
  #     key       = "ssh-rsa AAAAB3NzaC1yc2...."
  #     read_only = true
  #   },
  #   {
  #     title     = "Test Key"
  #     key       = "ssh-rsa AAAAB3NzaC1yc2...."
  #     read_only = false
  #   }
  # ]

  default = []
}

variable "deploy_keys_computed" {
  description = "Configure a deploy key ( SSH key ) that grants access to a single GitHub repository. This key is attached directly to the repository instead of to a personal user account."
  type        = any

  # Example:
  # deploy_keys_computed = [
  #   {
  #     title     = "CI User Deploy Key"
  #     key       = computed.resource
  #     read_only = true
  #   }
  # ]

  default = []
}

variable "projects" {
  description = "Create and manage projects for GitHub repository."
  type = list(object({
    name = string
    body = string
  }))

  # Example:
  # projects = [
  #   {
  #     name = "Testproject"
  #     body = "This is a fancy test project for testing"
  #   }
  # ]

  default = []
}
