output "repository" {
  description = "All outputs of the created repository."
  value       = module.repository
}

output "repository_name" {
  description = "The full name of the created repository"
  value       = module.repository.full_name
}

output "webhook_url" {
  description = "Events are being sent to this URL"
  value       = module.repository.webhooks[0].configuration[0].url
}

output "webhook_content_type" {
  description = "The content-type of the webhook"
  value       = module.repository.webhooks[0].configuration[0].content_type
}

output "webhook_insecure_ssl" {
  description = "TLS encryption configuration on the webhook"
  value       = module.repository.webhooks[0].configuration[0].insecure_ssl
}

output "webhook_secret" {
  description = "The shared secret for the webhook"
  value       = module.repository.webhooks[0].configuration[0].secret
}

output "webhook_active" {
  description = "Indicates if the webhook should receive events"
  value       = module.repository.webhooks[0].active
}

output "webhook_events" {
  description = "The events which will trigger this webhook"
  value       = module.repository.webhooks[0].events
}
