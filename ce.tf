resource "google_compute_instance" "minecraft_main_vm" {
  name                = "minecraft-main-vm"
  machine_type        = "e2-micro"
  tags                = ["http-server", "https-server", "ib-health-check"]
  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false

  boot_disk {
    auto_delete = false
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network    = "default"
    subnetwork = "default"
    access_config {
      network_tier = "PREMIUM"
    }
  }
  metadata = {
    "startup-script"  = file("startup.sh") 
    "enable-osconfig" = true
  }

  service_account {
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }

}