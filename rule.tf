resource "google_compute_firewall" "allow_ports" {
  for_each = var.firewall_rule

  name    = each.value.name
  network = each.value.network

  allow {
    protocol = each.value.protocol
    ports    = each.value.ports
  }

  target_tags   = each.value.target_tags
  source_ranges = each.value.source_ranges
}