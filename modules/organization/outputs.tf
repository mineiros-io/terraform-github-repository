output "username" {
  value = { for k, v in github_membership.membership : k => v.username }
}

output "role" {
  value = { for k, v in github_membership.membership : k => v.role }
}
