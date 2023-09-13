# This file defines the default firewall rules that are available on the platform.
# - default_allow_icmp: allows ICMP traffic from any source to any destination
# - default_allow_rdp: allows RDP traffic from any source to any destination
# - default_allow_ssh: allows SSH traffic from any source to any destination
# - default_allow_internal: allows all traffic from any source in the VPC to any destination in the VPC

resource "google_compute_firewall" "default_allow_icmp" {
  name          = "${var.network_name}-allow-icmp"
  network       = var.network_name
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  priority      = var.priority

  allow {
    protocol = "icmp"
  }
}

resource "google_compute_firewall" "default_allow_rdp" {
  name          = "${var.network_name}-allow-rdp"
  network       = var.network_name
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  priority      = var.priority

  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }
}

resource "google_compute_firewall" "default_allow_ssh" {
  name          = "${var.network_name}-allow-ssh"
  network       = var.network_name
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  priority      = var.priority

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_firewall" "default_allow_internal" {
  name     = "${var.network_name}-allow-internal"
  network  = var.network_name
  priority = var.priority
  direction = "INGRESS"

  allow {
    protocol = "all"
  }

  source_ranges = ["10.128.0.0/9"]
}

variable "network_name" {
  type = string
}

variable "priority" {
  type    = number
  default = 65534
}
