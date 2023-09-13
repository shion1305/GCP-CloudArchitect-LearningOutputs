resource "google_compute_network" "mynetwork" {
  name                    = "mynetwork"
  auto_create_subnetworks = "true"
}

module "default-firewalls" {
  source       = "./modules/firewalls-default"
  network_name = google_compute_network.mynetwork.name
}
