// the more i do this stuff the more i realise that having a single service account that does everything within\
// the infra is much more convenient.

resource "google_service_account" "main" {
  account_id   = "admin-${random_string.random.result}"
  display_name = "admin-${random_string.random.result}"
  description  = "Service account for most actions that we ever need in this context."
}

// will attach this service account to cloud run app (spring boot)
resource "google_project_iam_member" "run_admin" {
  project = var.GOOGLE_PROJECT
  role    = "roles/run.admin"
  member  = "serviceAccount:${google_service_account.main.email}"
}

// still not 100 percent sure why we need this
resource "google_project_iam_member" "artifact_writer" {
  project = var.GOOGLE_PROJECT
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.main.email}"
}

resource "google_project_iam_member" "sa_user" {
  project = var.GOOGLE_PROJECT
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.main.email}"
}

// this service account will also be attached to the vm so to use gsutil we need this
resource "google_project_iam_member" "bucket-interactor" {
  project = var.GOOGLE_PROJECT
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.main.email}"
}

// allows it to sign download urls- also need the IAM Api enabled on the marketplace
resource "google_project_iam_member" "signer" {
  project = var.GOOGLE_PROJECT
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:${google_service_account.main.email}"
}

// allows it to list buckets- we might need this for an updated version of the mod sync script
resource "google_project_iam_member" "bucket-lister" {
  project = var.GOOGLE_PROJECT
  role    = "roles/storage.bucketViewer"
  member  = "serviceAccount:${google_service_account.main.email}"
}

// making it admin of compute so it can create and manange vms
// at the time of writing this, there is no need for anything more than read access, but 
// at some point in the future, this same service account may be used to manage vms
resource "google_project_iam_member" "compute" {
  project = var.GOOGLE_PROJECT
  role    = "roles/compute.admin"
  member  = "serviceAccount:${google_service_account.main.email}"
}