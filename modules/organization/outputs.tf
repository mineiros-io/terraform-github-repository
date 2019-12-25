output "username" {
  value = github_membership.membership.*.username
}

output "role" {
  value = github_membership.membership.*.role
}
