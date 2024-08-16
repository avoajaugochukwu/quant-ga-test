output "role_arn" {
  description = "The ARN of the IAM role from the module."
  value       = module.github_oidc_role.role_arn
}

# output "name" {
#   description = "The name of the IAM role from the module."
#   value       = module.github_oidc_role.name 
# }