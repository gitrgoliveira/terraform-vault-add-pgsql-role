output "db_role_name" {
  description = "Database static role name created by this module."
  value       = vault_database_secret_backend_static_role.this.name
}

output "group_name" {
  description = "Identity group name granting database static credential read policy."
  value       = vault_identity_group.this.name
}

output "injector_yaml" {
  description = "Rendered Vault Agent Injector annotations snippet for static-creds path."
  value = templatefile("${path.module}/templates/injector-annotations.yaml.tftpl", {
    auth_role_name = local.auth_role_name
    db_mount_path  = var.db_mount_path
    db_role_name   = local.db_role_name
    jwt_auth_path  = local.jwt_auth_path
  })
}

output "policy_name" {
  description = "Database static credential read policy name."
  value       = vault_policy.this.name
}

output "vso_yaml" {
  description = "Rendered Vault Secrets Operator VaultAuth and VaultDynamicSecret snippet for static-creds path."
  value = templatefile("${path.module}/templates/vso-cr.yaml.tftpl", {
    auth_role_name = local.auth_role_name
    db_mount_path  = var.db_mount_path
    db_role_name   = local.db_role_name
    jwt_auth_path  = local.jwt_auth_path
    usecase_name   = var.usecase_name
    workload_name  = var.workload_name
  })
}
