resource "kubernetes_cluster_role_binding" "read_only_user" {
  metadata {
    name = "read-only-user-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "view"  # Predefined read-only role
  }

  subject {
    kind      = "User"
    name      = var.user_email
    api_group = "rbac.authorization.k8s.io"
  }
}