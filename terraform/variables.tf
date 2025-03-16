variable "region" {
    description = "Region in which GCP resources will be created"
    type        = string
    default     = "us-central1"
}

variable "project_id" {
    description = "Project ID"
    type        = string
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