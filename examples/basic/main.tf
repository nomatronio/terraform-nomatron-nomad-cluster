module "cluster" {
  source = "../.."

  name              = "platform-nomad"
  scope             = "global"
  connectivity_mode = "direct"
  address           = "https://nomad.example.test:4646"
  acl_token_wo      = var.nomad_acl_token
}
