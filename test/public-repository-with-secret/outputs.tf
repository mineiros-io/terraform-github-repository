output "repository" {
  description = "All outputs of the created repository."
  value       = module.repository
}

output "repository_name" {
  description = "The full name of the created repository"
  value       = module.repository.full_name
}

output "secret_name" {
  description = "Secret name"
  value       = module.repository.secrets[0]
}

