module "cluster" {
  source = "../.."

  name                         = var.name
  description                  = var.description
  scope                        = var.scope
  org_name                     = var.org_name
  connectivity_mode            = var.connectivity_mode
  address                      = var.address
  agent_id                     = var.agent_id
  create_network_agent         = var.create_network_agent
  network_agent                = var.network_agent
  mint_agent_token             = var.mint_agent_token
  agent_token_name             = var.agent_token_name
  agent_token_expires_at       = var.agent_token_expires_at
  revoke_existing_agent_tokens = var.revoke_existing_agent_tokens
  skip_verify                  = var.skip_verify
  acl_token_wo                 = var.acl_token_wo
  ca_cert_wo                   = var.ca_cert_wo
  tls_cert_wo                  = var.tls_cert_wo
  tls_key_wo                   = var.tls_key_wo
}
