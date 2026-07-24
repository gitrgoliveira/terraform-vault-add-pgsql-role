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

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,30}[a-z0-9]$", var.db_connection_name))
    error_message = "db_connection_name must match ^[a-z][a-z0-9-]{0,30}[a-z0-9]$."
  }
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

variable "workload_name" {
  type        = string
  description = "Workload identifier used in role, policy, and group naming."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,30}[a-z0-9]$", var.workload_name))
    error_message = "workload_name must match ^[a-z][a-z0-9-]{0,30}[a-z0-9]$."
  }
}
