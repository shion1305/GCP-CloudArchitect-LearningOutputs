resource "google_compute_network" "mynetwork" {
  name                    = "mynetwork"
  auto_create_subnetworks = "true"
}

module "default-firewalls" {
  source       = "./modules/firewalls-default"
  network_name = google_compute_network.mynetwork.name
}

resource "google_compute_instance" "mynet-us-vm" {
  name         = "mynet-us-vm"
  machine_type = "e2-micro"
  zone         = var.zone
  network_interface {
    network = google_compute_network.mynetwork.name
    access_config {
    }
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
}

resource "google_compute_instance" "mynet-eu-vm" {
  name         = "mynet-eu-vm"
  machine_type = "e2-micro"
  zone         = "europe-west1-c"
  network_interface {
    network = google_compute_network.mynetwork.name
    access_config {
    }
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
}