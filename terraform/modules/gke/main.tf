resource "google_container_cluster" "cluster" {
  name     = "helloweb3-cluster"
  location = var.region
  network  = var.vpc_network
  subnetwork = var.subnet_name

  node_pool {
    name       = "default-pool"
    node_count = var.node_count
    node_config {
      machine_type = var.machine_type
    }
  }

ip_allocation_policy {
  cluster_secondary_range_name = "pods-ip-range"
  services_secondary_range_name = "services-ip-range"
}

  addons_config {
    http_load_balancing {
      disabled = false
    }
  }

  cluster_autoscaling {
    enabled = true
    resource_limits {
      resource_type = "cpu"
      maximum = 2 # Max cores per node
    }
    resource_limits {
      resource_type = "memory"
      maximum = 4
    }
  }
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "kubernetes_namespace" "helloweb3" {
  metadata {
    name = "helloweb3"
  }
}

resource "kubernetes_namespace" "nginx" {
  metadata {
    name = "nginx"
  }
}

resource "kubernetes_namespace" "cert-manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "helm_release" "kube-prometheus" {
  name       = "kube-prometheus-stackr"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  repository = "https://prometheus-community.github.io/helm-charts"
  version    = "25.24.1"
  chart      = "prometheus"
}

resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "nginx"

}

