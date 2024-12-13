terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.0.0" 
    }
  }
  required_version = ">= 1.0.0"
}

provider "google" {
  credentials = file("key.json")
  project = "fine-citadel-442015-v3"
  region  = "asia-south1"
  zone    = "asia-south1-c"
}