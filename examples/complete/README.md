# Complete example

This example creates a global cluster in agent mode, creates a network agent, and mints an ephemeral agent token. Connect a secret resource with a write-only value attribute to `module.cluster.agent_token` in the same apply. The raw token is ephemeral and must not be printed or stored in state.

Set `TF_VAR_nomatron_address` and `TF_VAR_nomatron_token` before running Terraform. The provider token is sensitive. This example does not configure direct-mode ACL or TLS values because it uses agent mode.
