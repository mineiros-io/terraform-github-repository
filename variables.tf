variable "name" {
  type        = string
  description = "The name of the repository."
}

variable "description" {
  type        = string
  description = "A description of the repository."
  default     = ""
}

variable "homepage_url" {
  type        = string
  description = "homepage_url"
  default     = ""
}

variable "private" {
  type        = bool
  description = "Set to false to create a public repository."
  default     = true
}

variable "has_issues" {
  type        = bool
  description = "Set to true to enable the GitHub Issues features on the repository."
  default     = false
}

variable "has_projects" {
  type        = bool
  description = "Set to true to enable the GitHub Projects features on the repository. Per the github documentation when in an organization that has disabled repository projects it will default to false and will otherwise default to true. If you specify true when it has been disabled it will return an error."
  default     = false
}

variable "has_wiki" {
  type        = bool
  description = "Set to true to enable the GitHub Wiki features on the repository."
  default     = false
}

variable "allow_merge_commit" {
  type        = bool
  description = "Set to true to enable merge commits on the repository."
  default     = false
}

variable "allow_squash_merge" {
  type        = bool
  description = "Set to true to enable squash merges on the repository."
  default     = false
}

variable "allow_rebase_merge" {
  type        = bool
  description = "Set to true to enable rebase merges on the repository."
  default     = false
}

variable "has_downloads" {
  type        = bool
  description = "Set to true to enable the (deprecated) downloads features on the repository."
  default     = false
}

variable "auto_init" {
  type        = bool
  description = "Wether or not to produce an initial commit in the repository."
  default     = true
}

variable "gitignore_template" {
  type        = string
  description = "Use the name of the template without the extension. For example, Haskell. Available templates: https://github.com/github/gitignore"
  default     = ""
}

variable "license_template" {
  type        = string
  description = "Use the name of the template without the extension. For example, 'mit' or 'mpl-2.0'. Available licences: https://github.com/github/choosealicense.com/tree/gh-pages/_licenses"
  default     = ""
}

variable "default_branch" {
  type        = string
  description = "The name of the default branch of the repository. NOTE: This can only be set after a repository has already been created, and after a correct reference has been created for the target branch inside the repository. This means a user will have to omit this parameter from the initial repository creation and create the target branch inside of the repository prior to setting this attribute."
  default     = ""
}

variable "archived" {
  type        = bool
  description = "Specifies if the repository should be archived."
  default     = false
}

variable "topics" {
  type        = list(string)
  description = "The list of topics of the repository."
  default     = []
}

variable "admin_collaborators" {
  type        = list(string)
  description = "A list of users to add as collaborators granting them admin (full) permission."
  default     = []
}

variable "push_collaborators" {
  type        = list(string)
  description = "A list of users to add as collaborators granting them push (read-write) permission."
  default     = []
}

variable "pull_collaborators" {
  type        = list(string)
  description = "A list of users to add as collaborators granting them pull (read-only) permission."
  default     = []
}

variable "admin_team_ids" {
  type        = list(string)
  description = "A list of teams (by id) to grant admin (full) permission to."
  default     = []
}

variable "push_team_ids" {
  type        = list(string)
  description = "A list of teams (by id) to grant push (read-write) permission to."
  default     = []
}

variable "pull_team_ids" {
  type        = list(string)
  description = "A list of teams (by id) to grant pull (read-only) permission to."
  default     = []
}

variable "branch_protection_rules" {
  type = list(object({
    branch                 = string
    enforce_admins         = bool
    require_signed_commits = bool
    required_status_checks = object({
      strict   = bool
      contexts = list(string)
    })
    required_pull_request_reviews = object({
      dismiss_stale_reviews           = bool
      dismissal_users                 = list(string)
      dismissal_teams                 = list(string)
      require_code_owner_reviews      = bool
      required_approving_review_count = number
    })
    restrictions = object({
      users = list(string)
      teams = list(string)
    })
  }))
  description = "Configuring protected branches. For details please check: https://www.terraform.io/docs/providers/github/r/branch_protection.html"
  default     = []

  # Example:
  # branch_protection_rules = [
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
  #       dismissal_users                 = ["user1", "user2]
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

variable "issue_labels" {
  type = list(object({
    name        = string
    description = string
    color       = string
  }))
  description = "Configure a GitHub issue label resource."
  default     = []

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
}

variable "deploy_keys" {
  type = list(object({
    title     = string
    key       = string
    read_only = bool
  }))
  description = "Configure a deploy key ( SSH key ) that grants access to a single GitHub repository. This key is attached directly to the repository instead of to a personal user account."
  default     = []

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
}

variable "projects" {
  type = list(object({
    name = string
    body = string
  }))
  description = "Create and manage projects for GitHub repository."
  default     = []

  # Example:
  # projects = [
  #   {
  #     name = "Testproject"
  #     body = "This is a fancy test project for testing"
  #   }
  # ]
}
