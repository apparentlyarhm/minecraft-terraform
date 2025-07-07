resource "google_service_account" "github_deployer" {
  account_id   = "github-related"
  display_name = "GitHub Deployer Service Account"
  description  = "Service account for GitHub Actions to deploy to Google Cloud Run"
}

resource "google_project_iam_member" "run_admin" {
  project = var.GOOGLE_PROJECT
  role    = "roles/run.admin"
  member  = "serviceAccount:${google_service_account.github_deployer.email}"
}

resource "google_project_iam_member" "artifact_writer" {
  project = var.GOOGLE_PROJECT
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.github_deployer.email}"
}

resource "google_project_iam_member" "sa_user" {
  project = var.GOOGLE_PROJECT

  role   = "roles/iam.serviceAccountUser"
  member = "serviceAccount:${google_service_account.github_deployer.email}"
}
