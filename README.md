# Nomatron Nomad cluster Terraform module

This module registers one Nomad cluster with Nomatron. It can register a global cluster or an organization-scoped cluster and supports direct or agent connectivity. It can optionally create a Nomatron network agent and mint an ephemeral agent token.

The module does not manage overlay networking or etcd, and it does not install an agent on a Nomad host. It only manages resources exposed by the Nomatron Terraform provider.

## Requirements

| Name | Version |
| --- | --- |
| Terraform | `>= 1.11.0` |
| `nomatron` provider | `~> 0.6` |

The root module does not configure the provider. Configure it in the calling root module:

```hcl
terraform {
  required_providers {
    nomatron = {
      source  = "nomatronio/nomatron"
      version = "~> 0.6"
    }
  }
}

provider "nomatron" {
  address = var.nomatron_address
  token   = var.nomatron_token
}

module "cluster" {
  source = "nomatronio/nomad-cluster/nomatron"

  name              = "primary"
  scope             = "global"
  connectivity_mode = "direct"
  address           = "https://nomad.example.test:4646"
}
```

Supply provider credentials through variables such as `TF_VAR_nomatron_token`; do not put tokens in command-line arguments or commit them.

## Direct connectivity

Direct mode requires `address`. The optional `acl_token_wo`, `ca_cert_wo`, `tls_cert_wo`, and `tls_key_wo` inputs are write-only and sensitive; Terraform does not store their values in state. Set them only when `connectivity_mode = "direct"` and supply them through `TF_VAR_*` variables or another secret injection mechanism. `skip_verify` is optional; this module does not recommend disabling TLS verification.

## Agent connectivity and ephemeral tokens

Agent mode requires either an existing `agent_id` or `create_network_agent = true` with a `network_agent.name`. These two options are mutually exclusive. When requested, the module creates an ephemeral `nomatron_agent_token` for the `nomatron_network_agent` by setting `mint_agent_token = true`.

The `agent_token` output is ephemeral and sensitive, so Terraform does not store the raw token in state. Pass it directly to a secret store with a write-only value attribute in the same apply. Do not print it, save it to a local file, or expose it through a persistent output. Setting `revoke_existing_agent_tokens = true` revokes existing tokens during rotation.

```hcl
module "cluster" {
  source                = "nomatronio/nomad-cluster/nomatron"
  name                  = "primary"
  scope                 = "global"
  connectivity_mode   = "agent"
  create_network_agent = true
  network_agent = {
    name = "primary-agent"
  }
  mint_agent_token = true
}

# Connect a secret store resource here using module.cluster.agent_token
# in its write-only value argument.
```

## Inputs

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `name` | `string` | — | Cluster name. |
| `scope` | `string` | — | `global` or `organization`. |
| `org_name` | `string` | `null` | Required for organization scope and null for global scope. |
| `description` | `string` | `null` | Optional cluster description. |
| `connectivity_mode` | `string` | `null` | `direct` or `agent`; omitted mode is decided by the server. |
| `address` | `string` | `null` | Nomad API address for direct mode. |
| `agent_id` | `string` | `null` | Existing network agent ID. Mutually exclusive with `create_network_agent`. |
| `create_network_agent` | `bool` | `false` | Create a `nomatron_network_agent` and use it for the cluster. |
| `network_agent` | `object` | `null` | Network agent settings; requires a non-empty `name` when creating an agent. |
| `mint_agent_token` | `bool` | `false` | Mint an ephemeral token for the selected agent. |
| `agent_token_name` | `string` | `null` | Optional minted token display name. |
| `agent_token_expires_at` | `string` | `null` | Optional RFC3339 expiration timestamp. |
| `revoke_existing_agent_tokens` | `bool` | `null` | Whether token rotation revokes existing tokens. |
| `skip_verify` | `bool` | `null` | Whether TLS verification is skipped for direct connections. |
| `acl_token_wo` | `string` | `null` | Write-only Nomad ACL token for direct mode. |
| `ca_cert_wo` | `string` | `null` | Write-only CA certificate for direct mode. |
| `tls_cert_wo` | `string` | `null` | Write-only client certificate for direct mode. |
| `tls_key_wo` | `string` | `null` | Write-only client key for direct mode. |

## Outputs

| Name | Description |
| --- | --- |
| `id` | Cluster ID. |
| `name` | Cluster name. |
| `scope` | Scope reported by the provider. |
| `connectivity_mode` | Connectivity mode reported by the provider. |
| `agent_id` | Network agent ID used by the cluster, if any. |
| `agent_token` | Ephemeral sensitive token, null when minting is disabled. |
| `agent_token_id` | Ephemeral minted token ID, null when minting is disabled. |
| `agent_token_prefix` | Ephemeral token prefix, null when minting is disabled. |

## Importing existing resources

- Global cluster: import by cluster name.
- Organization cluster: import with `org_name/name`.
- Network agent: import by its UUID ID.

## Provider limitations

The provider currently leaves cluster `created_at` and `updated_at` unset in state. The module does not use those values.

## Examples and tests

See [`examples/basic`](examples/basic) and [`examples/complete`](examples/complete). Validate an example from its directory because it calls this module as a child module. For example:

```shell
terraform -chdir=examples/basic init -backend=false
terraform -chdir=examples/basic validate
```

Terraform only permits ephemeral outputs in child modules; validating this reusable module directly from its repository root reports `Ephemeral outputs are not allowed in context of a root module`.

The mock tests use a small parent-module harness for the same reason. Run them from the harness directory:

```shell
terraform -chdir=tests/harness init -backend=false
terraform -chdir=tests/harness test
```

The tests use a mocked provider and do not connect to a Nomatron server.

## License

Licensed under the Apache License, Version 2.0. See [LICENSE](LICENSE).
