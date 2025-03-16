resource "google_artifact_registry_repository" "docker" {
  location      = var.region
  repository_id = var.repo_id
  format        = var.format
}