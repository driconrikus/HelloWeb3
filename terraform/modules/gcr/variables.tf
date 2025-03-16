variable "region" {
    description = "Region for GCR"
    type        = string
    default     = "us-central1"
}

variable "repo_id" {
    description = "Name of the repository"
    type        = string
    default     = "hello-web3"
}

variable "format" {
    description = "Format of the repository"
    type        = string
    default     = "DOCKER"
}