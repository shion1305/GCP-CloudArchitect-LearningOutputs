resource "google_compute_network" "privatenet" {
  name                    = "privatenet"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "privatenet-us" {
  name          = "privatenet-us"
  ip_cidr_range = "10.130.0.0/20"
  network       = google_compute_network.privatenet.self_link
  region        = "us-central1"
}

resource "google_compute_firewall" "privatenet-allow-ssh" {
  name    = "privatenet-allow-ssh"
  network = google_compute_network.privatenet.self_link

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
}

resource "google_compute_instance" "vm-internal" {
  machine_type = "e2-medium"
  name         = "vm-internal"
  zone         = "us-central1-c"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network    = google_compute_network.privatenet.self_link
    subnetwork = google_compute_subnetwork.privatenet-us.self_link
  }
}

resource "google_storage_bucket" "bucket-1" {
  name          = "change-here-to-globally-unique-afjaioefnaiga"
  storage_class = "MULTI_REGIONAL"
  location      = "us"
  force_destroy = true
}
