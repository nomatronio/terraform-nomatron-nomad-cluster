# Basic example

This example registers one global Nomad cluster using direct connectivity.

Set the provider credentials with environment variables before planning:

```sh
export TF_VAR_nomatron_address="https://api.example.test"
export TF_VAR_nomatron_token="$NOMATRON_TOKEN"
export TF_VAR_nomad_acl_token="$NOMAD_ACL_TOKEN"
terraform init
terraform plan
```

Replace the example API and Nomad addresses with your own values. The provider token and Nomad ACL token are sensitive inputs supplied through environment variables. The ACL token maps to the module's write-only `acl_token_wo` input and is not stored in Terraform state.
