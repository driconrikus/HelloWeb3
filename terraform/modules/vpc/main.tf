# Create a VPC
resource "google_compute_network" "vpc" {
  name                    = "helloweb3-vpc"
  auto_create_subnetworks = false
}

# Create a subnet within the VPC
resource "google_compute_subnetwork" "subnet" {
  name          = "helloweb3-subnet"
  ip_cidr_range = "10.0.0.0/16"
  region        = var.region
  network       = google_compute_network.vpc.id
}
