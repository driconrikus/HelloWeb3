# Create a VPC
resource "google_compute_network" "vpc" {
  name                    = "helloweb3-vpc"
  routing_mode            = "REGIONAL"
  auto_create_subnetworks = false
}

# Create a subnet within the VPC
resource "google_compute_subnetwork" "subnet" {
  name          = "helloweb3-subnet"
  ip_cidr_range = "10.0.0.0/16"
  region        = var.region
  network       = google_compute_network.vpc.id
  private_ip_google_access = false

  secondary_ip_range {
    range_name    = "services-ip-range"
    ip_cidr_range = "10.1.0.0/16"
  }

  secondary_ip_range {
    range_name    = "pods-ip-range"
    ip_cidr_range = "10.2.0.0/16"
  }
}