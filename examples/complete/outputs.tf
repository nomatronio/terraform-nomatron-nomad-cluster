output "cluster_id" {
  description = "Nomatron cluster ID."
  value       = module.cluster.id
}

output "network_agent_id" {
  description = "Created network agent ID."
  value       = module.cluster.agent_id
}
