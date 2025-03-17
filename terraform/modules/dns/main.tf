# Assuming you are using Google Cloud DNS
resource "google_dns_managed_zone" "primary" {
  name     = var.dns_zone_name
  dns_name = var.dns_name 
  project  =  var.project_name
}

resource "google_dns_record_set" "a_record" {
  name    = var.dns_name # Note the trailing dot
  managed_zone = google_dns_managed_zone.primary.name
  type    = "A"
  ttl     = 300
  rrdatas = ["34.46.173.17"]
  project = var.project_name # Replace with your GCP project ID
}

output "nameservers" {
  value       = google_dns_managed_zone.primary.name_servers
  description = "The nameservers for your DNS zone. You need to configure these with your domain registrar."
}