locals {
  agent_id = var.create_network_agent ? nomatron_network_agent.this[0].id : var.agent_id
}

resource "nomatron_network_agent" "this" {
  count = var.create_network_agent ? 1 : 0

  name        = try(var.network_agent.name, null)
  description = try(var.network_agent.description, null)
  is_active   = try(var.network_agent.is_active, null)
}

resource "nomatron_nomad_cluster" "this" {
  count = var.scope == "global" ? 1 : 0

  name              = var.name
  description       = var.description
  connectivity_mode = var.connectivity_mode
  address           = var.address
  agent_id          = local.agent_id
  skip_verify       = var.skip_verify
  acl_token_wo      = var.acl_token_wo
  ca_cert_wo        = var.ca_cert_wo
  tls_cert_wo       = var.tls_cert_wo
  tls_key_wo        = var.tls_key_wo
}

resource "nomatron_organization_nomad_cluster" "this" {
  count = var.scope == "organization" ? 1 : 0

  org_name          = var.org_name
  name              = var.name
  description       = var.description
  connectivity_mode = var.connectivity_mode
  address           = var.address
  agent_id          = local.agent_id
  skip_verify       = var.skip_verify
  acl_token_wo      = var.acl_token_wo
  ca_cert_wo        = var.ca_cert_wo
  tls_cert_wo       = var.tls_cert_wo
  tls_key_wo        = var.tls_key_wo
}

ephemeral "nomatron_agent_token" "this" {
  count = var.mint_agent_token ? 1 : 0

  agent_id        = local.agent_id
  name            = var.agent_token_name
  expires_at      = var.agent_token_expires_at
  revoke_existing = var.revoke_existing_agent_tokens
}
