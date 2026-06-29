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
    auth_role_name  = var.auth_role_name
    db_mount_path   = var.db_mount_path
    db_role_name    = local.db_role_name
    jwt_auth_path   = var.jwt_auth_path
    vault_address   = var.vault_address
    vault_namespace = var.vault_namespace
  })
}

output "policy_name" {
  description = "Database static credential read policy name."
  value       = vault_policy.this.name
}

output "vso_yaml" {
  description = "Rendered Vault Secrets Operator VaultDynamicSecret snippet for static-creds path."
  value = templatefile("${path.module}/templates/vso-cr.yaml.tftpl", {
    auth_role_name      = var.auth_role_name
    db_mount_path       = var.db_mount_path
    db_role_name        = local.db_role_name
    jwt_auth_path       = var.jwt_auth_path
    k8s_namespace       = var.k8s_namespace
    k8s_service_account = var.k8s_service_account
    principal_name      = var.principal_name
    usecase_name        = var.usecase_name
    vault_namespace     = var.vault_namespace
  })
}
