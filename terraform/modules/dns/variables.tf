variable "dns_zone_name" {
    description = "The name of the DNS Zone"
    type = string
    default = "rvtest-site"
}

variable "dns_name" {
    description = "The name of the DNS"
    type = string
    default = "rvtest.site."
}

variable "project_name" {
    description = "Project ID"
    type = string
    default = "marine-storm-453819-c3"
}