# This file defines the default firewall rules that are available on the platform.
# - default_allow_icmp: allows ICMP traffic from any source to any destination
# - default_allow_rdp: allows RDP traffic from any source to any destination
# - default_allow_ssh: allows SSH traffic from any source to any destination
# - default_allow_internal: allows all traffic from any source in the VPC to any destination in the VPC

resource "google_compute_firewall" "default_allow_icmp" {
  name    = "default-allow-icmp"
  network = var.network_name
  direction = "INGRESS"
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "icmp"
  }
}

resource "google_compute_firewall" "default_allow_rdp" {
  name    = "default-allow-rdp"
  network = var.network_name
  direction = "INGRESS"
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }
}

resource "google_compute_firewall" "default_allow_ssh" {
  name    = "default-allow-ssh"
  network = var.network_name
  direction = "INGRESS"
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_firewall" "default_allow_internal" {
  name    = "default-allow-internal"
  network = var.network_name

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "icmp"
  }

  source_ranges = ["10.128.0.0/9"]
}

variable "network_name" {
  type = string
}
