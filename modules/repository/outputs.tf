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

output "collaborator_invitation_id" {
  value = { for k, v in github_repository_collaborator.collaborator : k => v.invitation_id }
}

output "project_url" {
  value = { for k, v in github_repository_project.repository_project : k => v.url }
}
