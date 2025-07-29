resource "google_compute_firewall" "minecraft_allow" {
  
  name          = "mc-main-${random_string.random.result}"
  network       = "default"
  source_ranges = ["1.1.1.1/32"] // Adding a private placeholder here. This will be edited via our cloud run app.
  
  allow {
    protocol    = "tcp"
    ports       = ["25565"]
  }

  allow {
     protocol    = "udp"
     ports       = ["25565"]
  }

  target_tags = ["mc"] // can leave hardcoded me thinks
}