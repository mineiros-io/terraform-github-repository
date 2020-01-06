variable "github_token" {
  type        = string
  description = "Github token used for deploying this example. Typically, we set this using variables on the command line to set the value inside our CI environment. https://www.terraform.io/docs/configuration/variables.html#variables-on-the-command-line"
  default     = null
}

variable "github_organization" {
  type        = string
  description = "Github organization used to deploy this module into. Typically, we set this using variables on the command line to set the value inside our CI environment. https://www.terraform.io/docs/configuration/variables.html#variables-on-the-command-line"
  default     = null
}
