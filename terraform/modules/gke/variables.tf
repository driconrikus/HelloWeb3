variable "region" {
  type = string
  default = "us-central1"
}

variable "vpc_network" {
  type = string
}

variable "subnet_name" {
  type = string
}

variable "machine_type" {
  type    = string
  default = "e2-standard-2"
}

variable "node_count" {
  type    = number
  default = 1
}