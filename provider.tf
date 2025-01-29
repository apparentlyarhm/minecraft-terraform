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
  
}

provider "google" {
  credentials = file("key.json")
  project = "fine-citadel-442015-v3"
  region  = "asia-south1"
  zone    = "asia-south1-a"
}
