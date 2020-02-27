output "repository" {
  description = "All outputs of the created repository."
  value       = module.repository
}

output "repository_name" {
  description = "The full name of the created repository"
  value       = module.repository.full_name
}

output "collaborators" {
  description = "A list of collaborators that are attached to the repository."
  value       = module.repository.collaborators
}

output "repository_url" {
  description = "The URL of the created repository."
  value       = module.repository.html_url
}
