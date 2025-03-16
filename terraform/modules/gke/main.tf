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
}