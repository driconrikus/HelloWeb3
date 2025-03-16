resource "google_project_iam_member" "gke_cluster_viewer" {
  project = var.project_id
  role    = "roles/container.clusterViewer"
  member  = "user:${var.user_email}"
}

resource "google_service_account" "github_actions" {
  count        = var.create_github_actions_sa ? 1 : 0  # Conditional creation
  project      = var.project_id
  account_id   = var.github_actions_account_id
  display_name = "GitHub Actions Service Account"
}

# Assign IAM roles to the GitHub Actions SA
resource "google_project_iam_member" "github_actions_roles" {
  for_each = toset(var.github_actions_roles)
  project  = var.project_id
  role     = each.key
  member   = "serviceAccount:${google_service_account.github_actions[0].email}"
}

# Generate JSON key (optional)
resource "google_service_account_key" "github_actions_key" {
  count              = var.create_github_actions_sa && var.generate_github_actions_key ? 1 : 0
  service_account_id = google_service_account.github_actions[0].name
}