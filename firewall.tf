resource "google_compute_firewall" "minecraft_allow" {
  
  name = "minecraft-allow-tcp"
  network = "default"
  source_ranges = ["192.168.1.1/32"] // Adding a private placeholder here. This will be edited via our cloud run app.
  
  allow {
    protocol = "tcp"
    ports = ["22"]
  }
}
  
resource "google_compute_firewall" "motd-allow" {

  name = "motd-allow"
  network = "default"
  source_ranges = ["0.0.0.0/0"] 
  
  allow {
    protocol = "udp"
    ports = ["25565"]
  }
}