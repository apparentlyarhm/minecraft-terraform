resource "google_compute_firewall" "minecraft_allow" {
  
  name          = "mc-main-${random_string.random.result}"
  network       = "default"
  source_ranges = ["1.1.1.1/32"] // Adding a private placeholder here. This will be edited via our cloud run app.
  
  // primary game traffic
  allow {
    protocol    = "tcp"
    ports       = ["25565"]
  }

  target_tags = ["mc"] // can leave hardcoded me thinks
}

// this firewall rule will allow every IP to view server status, should they know our custom port..
resource "google_compute_firewall" "motd_allow" {

  name          = "utils-main-${random_string.random.result}"
  network       = "default"
  source_ranges = ["0.0.0.0/0"]

  // rcon works on TCP
  allow {
     protocol    = "tcp"
     ports       = ["30000"]
  }
  
  // query works on UDP
  allow {
     protocol    = "udp"
     ports       = ["25565"]
  }

  target_tags = ["mc"] // can leave hardcoded me thinks
}