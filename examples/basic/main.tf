terraform {
  required_version = ">= 1.9"
}

locals {
  connection_db_connection_name = "payments-db"
  connection_db_mount_path      = "db/ocp-prod-eu/payments-db"
  trust_jwt_auth_path           = "jwt/ocp-prod-eu"
  workload_auth_role_name       = "ocp-prod-eu-payments"
  workload_cluster_name         = "ocp-prod-eu"
  workload_entity_id            = "11111111-2222-3333-4444-555555555555"
  workload_name                 = "payments"
}

module "add_pgsql_role" {
  source = "../../"

  auth_role_name     = local.workload_auth_role_name
  cluster_name       = local.workload_cluster_name
  db_connection_name = local.connection_db_connection_name
  db_mount_path      = local.connection_db_mount_path
  db_username        = var.db_username
  entity_id          = local.workload_entity_id
  jwt_auth_path      = local.trust_jwt_auth_path
  k8s_namespace      = var.k8s_namespace
  usecase_name       = var.usecase_name
  workload_name      = local.workload_name
}

variable "db_username" {
  type        = string
  description = "Existing PostgreSQL username to be managed by Vault static role."
}

variable "k8s_namespace" {
  type        = string
  description = "Namespace for rendered Kubernetes YAML snippets."
}

variable "usecase_name" {
  type        = string
  description = "Use-case identifier."
}
