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
  machine_type = "e2-standard-2"
}

# Create read-only IAM user for Kubernetes
module "iam" {
  source     = "./modules/iam"
  project_id = var.project_id
  user_email = "gothrickz@gmail.com"  # Replace with user email
  depends_on = [module.gke]
  create_github_actions_sa     = true
  github_actions_account_id    = "gha-deployer"  # Unique ID to avoid conflicts
  github_actions_roles         = ["roles/container.developer", "roles/storage.admin", "roles/artifactregistry.writer"]
  generate_github_actions_key  = true  # Only for testing; disable in productio
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
# Create repository in Google Container Registry
module "gcr" {
  source     = "./modules/gcr"
}

module "cert_manager" {
  source        = "terraform-iaac/cert-manager/kubernetes"
  create_namespace = false
  namespace_name = "cert-manager"

  cluster_issuer_email                   = var.cluster_issuer_email
  cluster_issuer_name                    = var.cluster_issuer_name
  cluster_issuer_private_key_secret_name = var.cluster_issuer_private_key_secret_name


  solvers = [
    {
      http01 = {
        ingress = {
          class = "nginx"
        }
      }
    }
  ]
}