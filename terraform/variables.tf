variable "region" {
    description = "Region in which GCP resources will be created"
    type        = string
    default     = "us-central1"
}

variable "project_id" {
    description = "Project ID"
    type        = string
    default     = "marine-storm-453819-c3"
}

variable "vpc" {
    description = "VPC for GKE"
    type        = string
    default     = "google_compute_network.helloweb3-vpc"
}

variable "subnet" {
    description = "Subnet for GKE"
    type        = string
    default     = "google_compute_subnetwork.helloweb3-subnet"
}

variable "cluster_issuer_email" {
  description = "The email address for the cluster issuer"
  type        = string
}

variable "cluster_issuer_name" {
  description = "The name of the cluster issuer"
  type        = string
  default     = "cert-manager-global"
}

variable "cluster_issuer_private_key_secret_name" {
  description = "The name of the secret for the cluster issuer private key"
  type        = string
  default     = "cert-manager-private-key"
}