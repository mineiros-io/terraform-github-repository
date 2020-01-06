output "full_name" {
  value = github_repository.repository.full_name
}

output "html_url" {
  value = github_repository.repository.html_url
}

output "ssh_clone_url" {
  value = github_repository.repository.ssh_clone_url
}

output "git_clone_url" {
  value = github_repository.repository.git_clone_url
}

output "collaborators" {
  value = github_repository_collaborator.collaborator
}

output "projects" {
  value = github_repository_project.repository_project
}
