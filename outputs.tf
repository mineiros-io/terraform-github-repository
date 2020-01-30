output "repository" {
  value       = github_repository.repository
  description = "All attributes and arguments as returned by the github_repository resource."
}

output "full_name" {
  value       = github_repository.repository.full_name
  description = "A string of the form 'orgname/reponame'."
}

output "html_url" {
  value       = github_repository.repository.html_url
  description = "URL to the repository on the web."
}

output "ssh_clone_url" {
  value       = github_repository.repository.ssh_clone_url
  description = "URL that can be provided to git clone to clone the repository via SSH."
}

output "http_clone_url" {
  value       = github_repository.repository.http_clone_url
  description = "URL that can be provided to git clone to clone the repository via HTTPS."
}

output "git_clone_url" {
  value       = github_repository.repository.git_clone_url
  description = "URL that can be provided to git clone to clone the repository anonymously via the git protocol."
}

output "collaborators" {
  value       = github_repository_collaborator.collaborator
  description = "A map of collaborator objects keyed by collaborator.name."
}

output "projects" {
  value       = github_repository_project.repository_project
  description = "A map of projects keyed by project input id."
}

output "issue_labels" {
  value       = github_issue_label.label
  description = "A map of issue labels keyed by label input id or name."
}

locals {
  deploy_keys_output = merge({
    for i, d in github_repository_deploy_key.deploy_key_computed :
    lookup(local.deploy_keys_computed_temp[i], "id", md5(d.key)) => d
  }, github_repository_deploy_key.deploy_key)
}

output "deploy_keys" {
  value       = local.deploy_keys_output
  description = "A map of deploy keys keyed by input id."
}
