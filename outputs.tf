output "id" {
  description = "Cluster ID."
  value       = try(nomatron_nomad_cluster.this[0].id, nomatron_organization_nomad_cluster.this[0].id)
}

output "name" {
  description = "Cluster name."
  value       = var.name
}

output "scope" {
  description = "Scope reported by the provider."
  value       = try(nomatron_nomad_cluster.this[0].scope, nomatron_organization_nomad_cluster.this[0].scope)
}

output "connectivity_mode" {
  description = "Connectivity mode reported by the provider."
  value       = try(nomatron_nomad_cluster.this[0].connectivity_mode, nomatron_organization_nomad_cluster.this[0].connectivity_mode)
}

output "agent_id" {
  description = "Network agent ID used by the cluster, if any."
  value       = local.agent_id
}

output "agent_token" {
  description = "Newly minted raw agent token. Ephemeral; pass it to a secret store in the same apply. Null when mint_agent_token is false."
  value       = try(ephemeral.nomatron_agent_token.this[0].token, null)
  ephemeral   = true
  sensitive   = true
}

output "agent_token_id" {
  description = "Minted token ID, or null when mint_agent_token is false."
  value       = try(ephemeral.nomatron_agent_token.this[0].token_id, null)
  ephemeral   = true
}

output "agent_token_prefix" {
  description = "Prefix of the minted token, or null when mint_agent_token is false."
  value       = try(ephemeral.nomatron_agent_token.this[0].token_prefix, null)
  ephemeral   = true
}
