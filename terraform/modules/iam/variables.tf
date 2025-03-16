variable "project_id" {
  description = "Google Cloud project ID"
  type        = string
}

variable "user_email" {
  description = "Email of the read-only user"
  type        = string
}

variable "create_github_actions_sa" {
  description = "Whether to create a service account for GitHub Actions"
  type        = bool
  default     = false
}

variable "github_actions_account_id" {
  description = "ID for the GitHub Actions service account"
  type        = string
  default     = "github-actions"
}

variable "github_actions_roles" {
  description = "List of IAM roles for the GitHub Actions SA"
  type        = list(string)
  default     = ["roles/container.developer", "roles/storage.admin"]
}

variable "generate_github_actions_key" {
  description = "Generate a JSON key for the GitHub Actions SA (not recommended for production)"
  type        = bool
  default     = false
}