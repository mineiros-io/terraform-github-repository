variable "blocked_users" {
  type        = list(string)
  description = "A list of usernames to be blocked from a GitHub organization."
  default     = []
}

variable "members" {
  type = list(object({
    username = string
    role     = string
  }))
  description = "A list of users to be added from your organization. When applied, an invitation will be sent to the user to become part of the organization. When destroyed, either the invitation will be cancelled or the user will be removed. Role must be one of member or admin."
  default     = []

  # Example:
  # members = [
  #   {
  #     username   = "username1"
  #     role       = "member"
  #   },
  #   {
  #     username   = "username2"
  #     role       = "admin"
  #   }
  # ]
}
