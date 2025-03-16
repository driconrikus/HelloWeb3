module "vpc" {
    source = "./modules/vpc"
    region = var.region
}

module "gke" {
  source       = "./modules/gke"
  cluster_name = "my-gke-cluster"
  region       = "us-central1"
  vpc_network  = module.vpc.vpc_id       # Pass VPC ID from the VPC module
  subnet_name  = module.vpc.subnet_name  # Pass subnet name from the VPC module
  machine_type = "e2-medium"
}