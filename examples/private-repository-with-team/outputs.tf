output "repository" {
  description = "All outputs of the repository."
  value       = module.repository
}

output "team" {
  description = "All outputs of the team."
  value       = github_team.team
}
