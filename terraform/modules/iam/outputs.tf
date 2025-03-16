output "github_actions_sa_email" {
  value       = var.create_github_actions_sa ? google_service_account.github_actions[0].email : null
  description = "Email of the GitHub Actions service account"
}

output "github_actions_sa_key" {
  value       = google_service_account_key.github_actions_key[0].private_key
  sensitive   = true
  description = "JSON Key for the Github Actions service account"
}