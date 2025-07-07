variable "GITHUB_TOKEN" {
    description = "GitHub token for accessing the GitHub API"
    type        = string
    sensitive   = true
}

variable "GITHUB_OWNER" {
    description = "GitHub owner for the repository"
    type        = string
}

variable "GOOGLE_PROJECT" {
    description = "Google Cloud project ID"
    type        = string
}

variable "GOOGLE_REGION" {
    description = "Google Cloud region for resources"
    type        = string
}

variable "MINECRAFT_VM_ZONE" {
    description = "Google Cloud zone for the Minecraft VM"
    type        = string
}