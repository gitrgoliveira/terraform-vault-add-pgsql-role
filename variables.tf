variable "auth_role_name" {
  type        = string
  description = "JWT auth role name used by workloads for login."
}

variable "cluster_name" {
  type        = string
  description = "Cluster identifier used in role, policy, and group naming."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,30}[a-z0-9]$", var.cluster_name))
    error_message = "cluster_name must match ^[a-z][a-z0-9-]{0,30}[a-z0-9]$."
  }
}

variable "db_connection_name" {
  type        = string
  description = "Database backend connection name from onboard-pgsql-connection output."
}

variable "db_mount_path" {
  type        = string
  description = "Database backend mount path from onboard-pgsql-connection output."

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]+(/[a-zA-Z0-9_.-]+)*$", var.db_mount_path))
    error_message = "db_mount_path must be a Vault mount path (alphanumerics, '-', '_', '.', '/'); no quotes, braces, or whitespace."
  }
}

variable "db_username" {
  type        = string
  description = "Existing PostgreSQL username managed by Vault static role."
}

variable "entity_id" {
  type        = string
  description = "Vault entity ID that receives this database policy via identity group membership."
}

variable "jwt_auth_path" {
  type        = string
  description = "JWT auth path used for rendered workload integration snippets."
}

variable "k8s_namespace" {
  type        = string
  description = "Kubernetes namespace used in rendered YAML snippets."
  default     = ""
}

variable "k8s_service_account" {
  type        = string
  description = "Workload Kubernetes ServiceAccount referenced by the rendered VaultAuth CR; VSO mints its projected JWT for Vault login."
  default     = "default"
}

variable "rotation_period" {
  type        = number
  description = "Static role password rotation period in seconds."
  default     = 86400
}

variable "usecase_name" {
  type        = string
  description = "Use-case identifier used in role, policy, and group naming."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,30}[a-z0-9]$", var.usecase_name))
    error_message = "usecase_name must match ^[a-z][a-z0-9-]{0,30}[a-z0-9]$."
  }
}

variable "vault_address" {
  type        = string
  description = "Render-only Vault address value supplied via TF_VAR_vault_address."
  default     = ""
}

variable "vault_namespace" {
  type        = string
  description = "Render-only Vault namespace value supplied via TF_VAR_vault_namespace."
  default     = ""
}

variable "workload_name" {
  type        = string
  description = "Workload identifier used in role, policy, and group naming."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,30}[a-z0-9]$", var.workload_name))
    error_message = "workload_name must match ^[a-z][a-z0-9-]{0,30}[a-z0-9]$."
  }
}
