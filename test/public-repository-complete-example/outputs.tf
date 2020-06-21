# ---------------------------------------------------------------------------------------------------------------------
# Repository
# ---------------------------------------------------------------------------------------------------------------------

output "repository" {
  description = "All outputs of the created repository."
  value       = module.repository
}

output "repository_name" {
  description = "The name of the created repository."
  value       = module.repository.full_name
}

# ---------------------------------------------------------------------------------------------------------------------
# Repository with defaults
# ---------------------------------------------------------------------------------------------------------------------

output "repository_defaults" {
  description = "A map of default settings that can be attached to a repository."
  value       = var.repository_defaults
}

output "repository_with_defaults" {
  description = "All outputs of the repository that has default settings attached to it."
  value       = module.repository-with-defaults
}

output "repository_with_defaults_name" {
  description = "The nam of the created repository that has default settings attached to it."
  value       = module.repository-with-defaults.full_name
}

# ---------------------------------------------------------------------------------------------------------------------
# Team
# ---------------------------------------------------------------------------------------------------------------------

output "team" {
  description = "All outputs of the created team."
  value       = github_team.team
}

output "team_name" {
  description = "The name of the created team."
  value       = github_team.team.name
}
