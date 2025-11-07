resource "google_compute_instance" "minecraft_main_vm" {
  zone                = var.MINECRAFT_VM_ZONE
  name                = "mc-machine-${random_string.random.result}"
  machine_type        = "e2-micro"
  tags                = ["http-server", "https-server", "ib-health-check", "mc"]
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

  // this is important for gsutil to talk to gcs
  service_account {
    email  = google_service_account.main.email
    scopes = [
      "storage-rw",
      "logging-write",
      "monitoring-write",
      "service-management",
      "service-control",
      "trace"
      ]
    }

}
