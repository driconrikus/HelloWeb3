resource "google_project_iam_member" "gke_cluster_viewer" {
  project = var.project_id
  role    = "roles/container.clusterViewer"
  member  = "user:${var.user_email}"
}