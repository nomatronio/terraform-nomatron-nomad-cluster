variable "nomatron_address" {
  type        = string
  description = "Nomatron API address."
}

variable "nomatron_token" {
  type        = string
  sensitive   = true
  description = "Nomatron API token. Supply through TF_VAR_nomatron_token."
}

variable "nomad_acl_token" {
  type        = string
  sensitive   = true
  description = "Nomad ACL token for direct mode. Supply through TF_VAR_nomad_acl_token."
}
