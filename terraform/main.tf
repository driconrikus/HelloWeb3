# Create VPC and Subnet
module "vpc" {
    source = "./modules/vpc"
    region = var.region
}

# Create Kubernetes cluster
module "gke" {
  source       = "./modules/gke"
  region       = "us-central1"
  vpc_network  = module.vpc.vpc_id       # Pass VPC ID from the VPC module
  subnet_name  = module.vpc.subnet_name  # Pass subnet name from the VPC module
  machine_type = "e2-medium"
}

# Create read-only IAM user for Kubernetes
module "iam" {
  source     = "./modules/iam"
  project_id = var.project_id
  user_email = "gothrickz@gmail.com"  # Replace with user email
}

# Attach role binding to read-only IAM user for Kubernetes
module "rbac" {
  source     = "./modules/rbac"
  user_email = "gothrickz@gmail.com"  # Must match IAM user email
}

# Ensure RBAC depends on GKE cluster creation
resource "null_resource" "dependency" {
  depends_on = [module.gke]
}