mock_provider "nomatron" {
  mock_resource "nomatron_nomad_cluster" {
    defaults = {
      id = "mock-global-cluster-id"
    }
  }

  mock_resource "nomatron_organization_nomad_cluster" {
    defaults = {
      id = "mock-org-cluster-id"
    }
  }

  mock_resource "nomatron_network_agent" {
    defaults = {
      id = "00000000-0000-4000-8000-000000000010"
    }
  }
}

run "basic_global_direct" {
  command = apply

  variables {
    name              = "global-cluster"
    scope             = "global"
    connectivity_mode = "direct"
    address           = "https://nomad.example.test:4646"
  }

  assert {
    condition     = output.cluster_id == "mock-global-cluster-id"
    error_message = "The basic case should create a global cluster."
  }

  assert {
    condition     = output.selected_scope == "global" && output.agent_id == null
    error_message = "The direct global case should select global scope without an agent."
  }
}

run "organization_direct" {
  command = apply

  variables {
    name              = "org-cluster"
    scope             = "organization"
    org_name          = "example-org"
    connectivity_mode = "direct"
    address           = "https://nomad.example.test:4646"
  }

  assert {
    condition     = output.cluster_id == "mock-org-cluster-id"
    error_message = "Organization scope should create an organization cluster."
  }

  assert {
    condition     = output.selected_scope == "organization"
    error_message = "The organization case should preserve organization scope."
  }
}

run "agent_mode_with_created_agent" {
  command = apply

  variables {
    name                 = "agent-cluster"
    scope                = "global"
    connectivity_mode    = "agent"
    create_network_agent = true
    network_agent = {
      name = "example-agent"
    }
  }

  assert {
    condition     = output.cluster_id == "mock-global-cluster-id" && output.agent_id == "00000000-0000-4000-8000-000000000010"
    error_message = "Agent mode should create a network agent and register the cluster with its ID."
  }
}

run "organization_scope_requires_org_name" {
  command = plan

  variables {
    name              = "invalid-org-cluster"
    scope             = "organization"
    connectivity_mode = "direct"
    address           = "https://nomad.example.test:4646"
  }

  expect_failures = [var.org_name]
}

run "global_scope_rejects_org_name" {
  command = plan

  variables {
    name              = "invalid-global-cluster"
    scope             = "global"
    org_name          = "example-org"
    connectivity_mode = "direct"
    address           = "https://nomad.example.test:4646"
  }

  expect_failures = [var.org_name]
}

run "agent_id_and_created_agent_are_mutually_exclusive" {
  command = plan

  variables {
    name                 = "invalid-agent-cluster"
    scope                = "global"
    connectivity_mode    = "agent"
    agent_id             = "00000000-0000-4000-8000-000000000001"
    create_network_agent = true
    network_agent = {
      name = "example-agent"
    }
  }

  expect_failures = [var.agent_id]
}

run "agent_mode_requires_agent" {
  command = plan

  variables {
    name              = "invalid-agent-mode-cluster"
    scope             = "global"
    connectivity_mode = "agent"
  }

  expect_failures = [var.connectivity_mode]
}

run "direct_mode_requires_address" {
  command = plan

  variables {
    name              = "invalid-direct-cluster"
    scope             = "global"
    connectivity_mode = "direct"
  }

  expect_failures = [var.connectivity_mode]
}

run "invalid_connectivity_mode" {
  command = plan

  variables {
    name              = "invalid-mode-cluster"
    scope             = "global"
    connectivity_mode = "relay"
  }

  expect_failures = [var.connectivity_mode]
}

run "invalid_scope" {
  command = plan

  variables {
    name  = "invalid-scope-cluster"
    scope = "regional"
  }

  expect_failures = [var.scope]
}
