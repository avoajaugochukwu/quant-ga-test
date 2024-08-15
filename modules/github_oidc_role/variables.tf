variable "role_name" {
  description = "The name of the IAM role."
  type        = string
}

variable "policy_name" {
  description = "The name of the IAM policy."
  type        = string
}

variable "repository" {
  description = "The GitHub repository in the format 'owner/repo' for the OIDC condition."
  type        = string
}