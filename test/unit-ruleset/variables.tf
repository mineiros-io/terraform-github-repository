variable "name" {
  type        = string
  description = "Repository name used for test."
}

variable "ruleset_name" {
  type        = string
  description = "Ruleset name used for test."
}

variable "status_check_context" {
  type        = string
  default     = "ci/test"
  description = "Status check context required by the ruleset."
}
