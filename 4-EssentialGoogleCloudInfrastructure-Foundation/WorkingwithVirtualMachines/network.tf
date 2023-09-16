data "google_compute_network" "default-nw" {
  name = "default"
}

resource "google_compute_firewall" "allow-minecraft" {
  name    = "minecraft-rule"
  network = data.google_compute_network.default-nw.name

  allow {
    protocol = "tcp"
    ports    = ["25565"]
  }

  source_ranges = ["0.0.0.0/0"]
}
