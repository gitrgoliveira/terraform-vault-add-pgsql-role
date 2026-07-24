terraform {
  required_version = ">= 1.9"
}

locals {
  connection_db_connection_name = "payments-db"
  connection_db_mount_path      = "db/ocp-prod-eu/payments-db"
  workload_cluster_name         = "ocp-prod-eu"
  workload_name                 = "payments"
}

module "add_pgsql_role" {
  source = "../../"

  cluster_name       = local.workload_cluster_name
  db_connection_name = local.connection_db_connection_name
  db_mount_path      = local.connection_db_mount_path
  db_username        = var.db_username
  usecase_name       = var.usecase_name
  workload_name      = local.workload_name
}

variable "db_username" {
  type        = string
  description = "Existing PostgreSQL username to be managed by Vault static role."
}

variable "usecase_name" {
  type        = string
  description = "Use-case identifier."
}
