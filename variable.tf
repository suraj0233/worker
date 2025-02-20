variable "spacelift_token" {
  description = "Spacelift token for authentication"
  type        = string
  sensitive   = true
}
variable "spacelift_access_key" {
  description = "Spacelift API Access Key"
  type        = string
  sensitive   = true
}

variable "spacelift_secret_key" {
  description = "Spacelift API Secret Key"
  type        = string
  sensitive   = true
}
