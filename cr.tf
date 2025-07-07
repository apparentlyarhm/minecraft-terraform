resource "google_cloud_run_service" "mc_validator" {
  name     = "mc-validator"
  location = var.GOOGLE_REGION
  
}
