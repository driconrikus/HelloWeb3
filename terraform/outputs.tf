output "gha_sa_email" {
  value = module.iam.github_actions_sa_email
}

output "gha_sa_key" {
  value     = module.iam.github_actions_sa_key
  sensitive = true
}