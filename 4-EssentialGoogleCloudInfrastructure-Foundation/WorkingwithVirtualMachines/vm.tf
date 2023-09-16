resource "google_compute_instance" "mc-server" {
  name         = "mc-server"
  zone         = "us-central1-a"
  machine_type = "e2-medium"
  service_account {
    # specify "cloud-platform" to grant full access
    # in this case, we are only granting read/write access to Cloud Storage
    scopes = ["storage-rw"]
  }
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size  = 50
      type  = "pd-ssd"
    }
  }
  # tags refer to network tags
  tags = ["minecraft-server"]
  network_interface {
    # assume default network to be existing
    network = data.google_compute_network.default-nw.name

    access_config {
      # using the reserved IP address
      nat_ip = google_compute_global_address.mc-server-ip.address
    }
  }


  metadata_startup_script = <<SCRIPT
  #!/bin/bash
  # commands written here will be executed when the instance is created
  sudo mkdir -p /home/minecraft && \
  sudo mkfs.ext4 -F -E lazy_itable_init=0,\
  lazy_journal_init=0,discard && \
  /dev/disk/by-id/google-minecraft-disk && \
  sudo mount -o discard,defaults /dev/disk/by-id/google-minecraft-disk /home/minecraft && \
  sudo apt-get update && \
  sudo apt-get install -y default-jre-headless && \
  cd /home/minecraft
  sudo apt-get install -y wget && \
  sudo wget https://launcher.mojang.com/v1/objects/d0d0fe2b1dc6ab4c65554cb734270872b72dadd6/server.jar && \
  sudo echo "eula=true" > eula.txt && \
  nohup sudo java -Xmx1024M -Xms1024M -jar server.jar nogui &
  SCRIPT

  metadata = {
    startup-script-url  = "https://storage.googleapis.com/cloud-training/archinfra/mcserver/startup.sh"
    shutdown-script-url = "https://storage.googleapis.com/cloud-training/archinfra/mcserver/shutdown.sh"
  }
}

resource "google_compute_global_address" "mc-server-ip" {
  name = "mc-server-ip"
}
