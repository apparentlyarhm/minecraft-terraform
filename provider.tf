terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.0.0" 
    }
    github = {
      source = "integrations/github"
      version = "6.5.0"
    }
  }
}


provider "github" {
  token = var.GITHUB_TOKEN
  owner = var.GITHUB_OWNER
  
}

provider "google" {
  credentials = file("terraform-sa-key.json")
  project = var.GOOGLE_PROJECT
  // region and zone can be resoruce specific.
}
