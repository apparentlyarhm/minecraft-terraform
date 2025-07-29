resource "google_artifact_registry_repository" "mc-validator_repo" {
  location      = var.GOOGLE_REGION
  repository_id = "mc-validator-repo-${random_string.random.result}"
  description   = "Repository for the validator service"
  format        = "DOCKER"
}