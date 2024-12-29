resource "google_compute_firewall" "minecraft_allow" {
  
  name = "minecraft-allow-tcp"
  network = "default"
  source_ranges = ["192.168.1.1/32"] // Adding a private placeholder here. This will be edited via our app enigne app.
  
  allow {
    protocol = "tcp"
    ports = ["22"]
  }
}