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
  description = "Set to true to create a private repository."
  default     = false
}

variable "has_issues" {
  type        = bool
  description = "Set to true to enable the GitHub Issues features on the repository."
  default     = true
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
  description = "Set to false to disable merge commits on the repository."
  default     = true
}

variable "allow_squash_merge" {
  type        = bool
  description = "Set to false to disable squash merges on the repository."
  default     = true
}

variable "allow_rebase_merge" {
  type        = bool
  description = "Set to false to disable rebase merges on the repository."
  default     = true
}

variable "has_downloads" {
  type        = bool
  description = "Set to true to enable the (deprecated) downloads features on the repository."
  default     = false
}

variable "auto_init" {
  type        = bool
  description = "Set to true to produce an initial commit in the repository."
  default     = false
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

variable "collaborators" {
  type = list(object({
    username   = string
    permission = string
  }))
  description = "A list of users that should be invited as collaborator to the current repository. Permission must be one of pull, push, or admin."
  default     = []
  # Example:
  # collaborators = [
  #   {
  #     username   = "username1"
  #     permission = "admin"
  #   },
  #   {
  #     username   = "username2"
  #     permission = "pull"
  #   }
  # ]
}

variable "teams" {
  type = list(object({
    id         = string
    permission = string
  }))
  description = "A list of teams that should be invited as collaborator to the current repository. Permission must be one of pull, push, or admin."
  default     = []
  # Example:
  # collaborators = [
  #   {
  #     id         = "team-1"
  #     permission = "admin"
  #   },
  #   {
  #     id         = "team-2"
  #     permission = "pull"
  #   }
  # ]
}
