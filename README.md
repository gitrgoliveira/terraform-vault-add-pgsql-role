# terraform-vault-add-pgsql-role

Use-case module that creates a PostgreSQL static role, static-creds read policy, and identity group binding for one workload entity.

## Layer

Use-case.

## Prerequisites

- Workload module output `entity_id` and `auth_role_name`
- Trust module output `jwt_auth_path`
- Connection module outputs `db_mount_path` and `db_connection_name`

## Inputs

| Name | Type | Description |
|---|---|---|
| `cluster_name` | `string` | Cluster identifier, regex validated |
| `workload_name` | `string` | Workload identifier, regex validated |
| `usecase_name` | `string` | Use-case identifier, regex validated |
| `entity_id` | `string` | Workload entity ID |
| `auth_role_name` | `string` | Workload login role name |
| `jwt_auth_path` | `string` | Trust JWT auth path |
| `db_mount_path` | `string` | Database backend mount path |
| `db_connection_name` | `string` | Database backend connection name |
| `db_username` | `string` | Existing PostgreSQL username |
| `rotation_period` | `number` | Static role rotation period, default `86400` |
| `k8s_namespace` | `string` | YAML render namespace |
| `k8s_service_account` | `string` | Workload ServiceAccount for the rendered VaultAuth CR, default `default` |
| `vault_namespace` | `string` | Render-only |
| `vault_address` | `string` | Render-only |

## Outputs

| Name | Description |
|---|---|
| `db_role_name` | Static role name |
| `policy_name` | Static-creds read policy name |
| `group_name` | Identity group name |
| `injector_yaml` | Vault Agent Injector annotations YAML |
| `vso_yaml` | Vault Secrets Operator VaultDynamicSecret YAML |

## No-code notes

- One module run grants one workload one database static-creds use-case.
- Authorization is delivered through identity group membership (`member_entity_ids = [entity_id]`).

## No-code provisioning

This module is no-code enabled in the `hc-ric-demo` private registry (pinned to `0.1.0`). Click **Provision workspace**, pick a project and workspace name, then complete the form. Connection outputs come from `pgsql-onboarding`; `entity_id` and `auth_role_name` from the workload module.

Form fields:

| Field | Required | Notes |
|---|---|---|
| `cluster_name` | yes | Cluster identifier |
| `workload_name` | yes | Workload identifier |
| `usecase_name` | yes | Use-case identifier |
| `entity_id` | yes | Workload entity ID |
| `auth_role_name` | yes | Workload login role |
| `jwt_auth_path` | yes | From trust module |
| `db_mount_path` / `db_connection_name` | yes | From connection module |
| `db_username` | yes | Existing PostgreSQL user |

## Registry usage

```hcl
module "add_pgsql_role" {
  source  = "app.terraform.io/<org>/add-pgsql-role/vault"
  version = "~> 0.1.0"

  cluster_name       = "ocp-prod-eu"
  workload_name      = "payments"
  usecase_name       = "orders-db"
  entity_id          = "11111111-2222-3333-4444-555555555555"
  auth_role_name     = "ocp-prod-eu-payments"
  jwt_auth_path      = "jwt/ocp-prod-eu"
  db_mount_path      = "db/ocp-prod-eu/payments-db"
  db_connection_name = "payments-db"
  db_username        = "payments_app"
  k8s_namespace      = "payments-ns"
}
```

## Example rendered YAML

`injector_yaml` example:

```yaml
vault.hashicorp.com/agent-inject: "true"
vault.hashicorp.com/role: "ocp-prod-eu-payments"
vault.hashicorp.com/auth-path: "jwt/ocp-prod-eu"
vault.hashicorp.com/service: "https://vault.example.com"
vault.hashicorp.com/namespace: "admin/prod/payments"
vault.hashicorp.com/agent-inject-secret-db.json: "db/ocp-prod-eu/payments-db/static-creds/ocp-prod-eu-payments-orders-db-pg"
```

`vso_yaml` example:

```yaml
apiVersion: secrets.hashicorp.com/v1beta1
kind: VaultDynamicSecret
metadata:
  name: payments-orders-db
  namespace: payments-ns
spec:
  vaultAuthRef: ocp-prod-eu-payments
  mount: db/ocp-prod-eu/payments-db
  path: static-creds/ocp-prod-eu-payments-orders-db-pg
  destination:
    create: true
    name: payments-orders-db
  refreshAfter: 30s
```
