variable "name" {
  type = string
  validation {
    condition     = length(trimspace(var.name)) > 0
    error_message = "name must be a non-empty string."
  }
}

variable "description" {
  type    = string
  default = null
}

variable "scope" {
  type = string
  validation {
    condition     = contains(["global", "organization"], var.scope)
    error_message = "scope must be global or organization."
  }
}

variable "org_name" {
  type    = string
  default = null
  validation {
    condition     = var.scope == "organization" ? (var.org_name != null && length(trimspace(var.org_name)) > 0) : var.org_name == null
    error_message = "org_name must be a non-empty string for organization scope and null for global scope."
  }
}

variable "connectivity_mode" {
  type    = string
  default = null
  validation {
    condition     = var.connectivity_mode == null || contains(["direct", "agent"], var.connectivity_mode)
    error_message = "connectivity_mode must be direct or agent when set."
  }
  validation {
    condition = var.connectivity_mode == null || (var.connectivity_mode == "direct" ? (
      var.address != null && length(trimspace(var.address)) > 0 && var.agent_id == null && !var.create_network_agent
      ) : (
      (var.agent_id != null && length(trimspace(var.agent_id)) > 0) || var.create_network_agent
    ))
    error_message = "direct mode requires address and no agent; agent mode requires agent_id or create_network_agent."
  }
}

variable "address" {
  type    = string
  default = null
}

variable "agent_id" {
  type    = string
  default = null
  validation {
    condition     = var.agent_id == null || (length(trimspace(var.agent_id)) > 0 && !var.create_network_agent)
    error_message = "agent_id must be a non-empty ID and cannot be set with create_network_agent."
  }
}

variable "create_network_agent" {
  type    = bool
  default = false
}

variable "network_agent" {
  type = object({
    name        = string
    description = optional(string)
    is_active   = optional(bool)
  })
  default  = null
  nullable = true
  validation {
    condition     = !var.create_network_agent || (var.network_agent != null && length(trimspace(var.network_agent.name)) > 0)
    error_message = "network_agent with a non-empty name is required when create_network_agent is true."
  }
}

variable "mint_agent_token" {
  type    = bool
  default = false
  validation {
    condition     = !var.mint_agent_token || var.create_network_agent || (var.agent_id != null && length(trimspace(var.agent_id)) > 0)
    error_message = "mint_agent_token requires create_network_agent or an existing agent_id."
  }
}

variable "agent_token_name" {
  type    = string
  default = null
}

variable "agent_token_expires_at" {
  type    = string
  default = null
}

variable "revoke_existing_agent_tokens" {
  type    = bool
  default = null
}

variable "skip_verify" {
  type    = bool
  default = null
}

variable "acl_token_wo" {
  type      = string
  default   = null
  sensitive = true
  validation {
    condition     = var.acl_token_wo == null || var.connectivity_mode == "direct"
    error_message = "acl_token_wo can only be set when connectivity_mode is direct."
  }
}

variable "ca_cert_wo" {
  type      = string
  default   = null
  sensitive = true
  validation {
    condition     = var.ca_cert_wo == null || var.connectivity_mode == "direct"
    error_message = "ca_cert_wo can only be set when connectivity_mode is direct."
  }
}

variable "tls_cert_wo" {
  type      = string
  default   = null
  sensitive = true
  validation {
    condition     = var.tls_cert_wo == null || var.connectivity_mode == "direct"
    error_message = "tls_cert_wo can only be set when connectivity_mode is direct."
  }
}

variable "tls_key_wo" {
  type      = string
  default   = null
  sensitive = true
  validation {
    condition     = var.tls_key_wo == null || var.connectivity_mode == "direct"
    error_message = "tls_key_wo can only be set when connectivity_mode is direct."
  }
}
