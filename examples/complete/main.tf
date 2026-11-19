module "cluster" {
  source = "../.."

  name                 = "primary"
  scope                = "global"
  connectivity_mode    = "agent"
  create_network_agent = true
  network_agent = {
    name        = "primary-agent"
    description = "Network agent for the primary cluster"
  }

  mint_agent_token = true
  agent_token_name = "terraform"

  # ACL and TLS values are only for direct mode. Supply them through TF_VAR_*
  # when using direct mode; do not set them for this agent-mode example.
}

# Illustrative only: pass the ephemeral token directly to a secret resource
# with a write-only value attribute. Do not print or persist the token.
# resource "example_secret" "agent_token" {
#   name             = "nomatron-network-agent-token"
#   value_wo         = module.cluster.agent_token
#   value_wo_version = module.cluster.agent_token_id
# }
