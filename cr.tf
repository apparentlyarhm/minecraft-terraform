resource "google_cloud_run_service" "mc_validator" {
  name     = "mc-validator-${random_string.random.result}"
  location = var.GOOGLE_REGION
}
