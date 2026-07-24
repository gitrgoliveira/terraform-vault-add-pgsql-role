provider "vault" {
  skip_child_token = true
}

locals {
  auth_role_name = "${var.cluster_name}-${var.workload_name}"
  db_role_name   = "${var.cluster_name}-${var.workload_name}-${var.usecase_name}-pg"
  group_name     = "${var.cluster_name}-${var.workload_name}-${var.usecase_name}-db"
  jwt_auth_path  = "jwt/${var.cluster_name}"
  policy_name    = "${var.cluster_name}-${var.workload_name}-${var.usecase_name}-db-read"
}

data "vault_identity_entity" "workload" {
  entity_name = local.auth_role_name
}

resource "vault_database_secret_backend_static_role" "this" {
  backend         = var.db_mount_path
  db_name         = var.db_connection_name
  name            = local.db_role_name
  username        = var.db_username
  rotation_period = var.rotation_period
}

resource "vault_policy" "this" {
  name = local.policy_name

  policy = <<-EOT
path "${var.db_mount_path}/static-creds/${local.db_role_name}" {
  capabilities = ["read"]
}
EOT
}

resource "vault_identity_group" "this" {
  name              = local.group_name
  type              = "internal"
  policies          = [vault_policy.this.name]
  member_entity_ids = [data.vault_identity_entity.workload.id]
}
