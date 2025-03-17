output "gha_sa_email" {
  value = module.iam.github_actions_sa_email
}

output "gha_sa_key" {
  value     = module.iam.github_actions_sa_key
  sensitive = true
}

output "cluster_endpoint" {
  value = module.gke.endpoint
}

output "cluster_ca_certificate" {
  value = module.gke.cluster_ca_certificate
  sensitive = true
}