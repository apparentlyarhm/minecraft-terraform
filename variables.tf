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