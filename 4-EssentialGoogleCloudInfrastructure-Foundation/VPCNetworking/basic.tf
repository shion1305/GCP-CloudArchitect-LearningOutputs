resource "google_compute_network" "mynetwork" {
  name                    = "mynetwork"
  auto_create_subnetworks = "true"
  #  # YOU WILL BE ASKED TO CHANGE FROM AUTO TO CUSTOM ON DASHBOARD, BUT IT IS NOT POSSIBLE ON TERRAFORM
  #  auto_create_subnetworks = false
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

# managementnet is for step 3
resource "google_compute_network" "managementnet" {
  name                    = "managementnet"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "managementnet-subnet-us" {
  name          = "managementsubnet-us"
  ip_cidr_range = "10.240.0.0/20"
  network       = google_compute_network.managementnet.name
  region        = var.region
}

resource "google_compute_network" "privatenet" {
  name                    = "privatenet"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "privatesubnet-us" {
  name          = "privatesubnet-us"
  ip_cidr_range = "172.16.0.0/24"
  region        = var.region
  network       = google_compute_network.privatenet.name
}

resource "google_compute_subnetwork" "privatesubnet-eu" {
  name          = "privatesubnet-eu"
  ip_cidr_range = "172.20.0.0/20"
  region        = "europe-west1"
  network       = google_compute_network.privatenet.name
}

resource "google_compute_firewall" "managementnet-allow-icmp-ssh-rdp" {
  name    = "managementnet-allow-icmp-ssh-rdp"
  network = google_compute_network.managementnet.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "3389"]
  }

  allow {
    protocol = "udp"
    ports    = ["3389"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "privatenet-allow-icmp-ssh-rdp" {
  name    = "privatenet-allow-icmp-ssh-rdp"
  network = google_compute_network.privatenet.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "3389"]
  }

  allow {
    protocol = "udp"
    ports    = ["3389"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "managementnet-us-vm" {
  name         = "managementnet-us-vm"
  machine_type = "e2-micro"
  zone         = var.zone
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network    = google_compute_network.managementnet.name
    subnetwork = google_compute_subnetwork.managementnet-subnet-us.name
    access_config {}
  }
}

resource "google_compute_instance" "privatenet-us-vm" {
  name         = "privatenet-us-vm"
  machine_type = "e2-micro"
  zone         = var.zone
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size  = 10
      type  = "pd-balanced"
    }
  }
  network_interface {
    subnetwork = google_compute_subnetwork.privatesubnet-us.name
    access_config {}
  }
}


