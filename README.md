# terraform-vault-add-pgsql-role

Use-case module that creates a PostgreSQL static role, static-creds read policy, and identity group binding for one workload entity.

## Layer

Use-case.

## Prerequisites

- Workload module must be applied first (entity is looked up by name `<cluster_name>-<workload_name>`)
- Connection module outputs `db_mount_path` and `db_connection_name`

## Inputs

| Name | Type | Description |
|---|---|---|
| `cluster_name` | `string` | Cluster identifier, regex validated |
| `db_connection_name` | `string` | Database backend connection name |
| `db_mount_path` | `string` | Database backend mount path |
| `db_username` | `string` | Existing PostgreSQL username |
| `rotation_period` | `number` | Static role rotation period, default `86400` |
| `usecase_name` | `string` | Use-case identifier, regex validated |
| `workload_name` | `string` | Workload identifier, regex validated |

## Outputs

| Name | Description |
|---|---|
| `db_role_name` | Static role name |
| `policy_name` | Static-creds read policy name |
| `group_name` | Identity group name |
| `injector_yaml` | Vault Agent Injector annotations YAML |
| `vso_yaml` | Vault Secrets Operator VaultAuth and VaultDynamicSecret YAML |

## No-code notes

- One module run grants one workload one database static-creds use-case.
- Authorization is delivered through identity group membership (entity looked up by name).
- `auth_role_name` and `jwt_auth_path` are derived from `cluster_name` and `workload_name`.
- Template placeholders `<VAULT_ADDRESS>`, `<VAULT_NAMESPACE>`, `<K8S_NAMESPACE>`, and `<K8S_SERVICE_ACCOUNT>` must be replaced with environment-specific values after rendering.

## No-code provisioning

This module is no-code enabled in the `hc-ric-demo` private registry (pinned to `0.4.2`). Click **Provision workspace**, pick a project and workspace name, then complete the form. Connection outputs come from `pgsql-onboarding`; the workload module must be applied first so the entity can be discovered.

Form fields:

| Field | Required | Notes |
|---|---|---|
| `cluster_name` | yes | Cluster identifier |
| `db_connection_name` | yes | From connection module |
| `db_mount_path` | yes | From connection module |
| `db_username` | yes | Existing PostgreSQL user |
| `usecase_name` | yes | Use-case identifier |
| `workload_name` | yes | Workload identifier |

## Registry usage

```hcl
module "add_pgsql_role" {
  source  = "app.terraform.io/<org>/add-pgsql-role/vault"
  version = "~> 0.4.2"

  cluster_name       = "ocp-prod-eu"
  workload_name      = "payments"
  usecase_name       = "orders-db"
  db_mount_path      = "db/ocp-prod-eu/payments-db"
  db_connection_name = "payments-db"
  db_username        = "payments_app"
}
```

## Example rendered YAML

`injector_yaml` example:

```yaml
# JWT auth reads a projected ServiceAccount token with audience "vault", the
# workload module's default bound_audience (change both if you overrode it).
# Add this volume to the pod spec, without mounting it in the app container:
#   volumes:
#     - name: vault-token
#       projected:
#         sources:
#           - serviceAccountToken:
#               path: token
#               audience: vault
vault.hashicorp.com/agent-inject: "true"
vault.hashicorp.com/role: "ocp-prod-eu-payments"
vault.hashicorp.com/auth-type: "jwt"
vault.hashicorp.com/auth-path: "auth/jwt/ocp-prod-eu"
vault.hashicorp.com/agent-service-account-token-volume-name: "vault-token"
vault.hashicorp.com/auth-config-path: "/var/run/secrets/vault.hashicorp.com/serviceaccount/token"
vault.hashicorp.com/auth-config-remove-jwt-after-reading: "false"
vault.hashicorp.com/service: "<VAULT_ADDRESS>"
vault.hashicorp.com/namespace: "<VAULT_NAMESPACE>"
vault.hashicorp.com/agent-inject-secret-db.json: "db/ocp-prod-eu/payments-db/static-creds/ocp-prod-eu-payments-orders-db-pg"
```

`vso_yaml` example:

```yaml
apiVersion: secrets.hashicorp.com/v1beta1
kind: VaultAuth
metadata:
  name: payments-orders-db-auth
  namespace: <K8S_NAMESPACE>
spec:
  method: jwt
  mount: jwt/ocp-prod-eu
  namespace: <VAULT_NAMESPACE>
  jwt:
    role: ocp-prod-eu-payments
    serviceAccount: <K8S_SERVICE_ACCOUNT>
    audiences:
      - vault # the workload module's bound_audience
---
apiVersion: secrets.hashicorp.com/v1beta1
kind: VaultDynamicSecret
metadata:
  name: payments-orders-db
  namespace: <K8S_NAMESPACE>
spec:
  vaultAuthRef: payments-orders-db-auth
  mount: db/ocp-prod-eu/payments-db
  path: static-creds/ocp-prod-eu-payments-orders-db-pg
  allowStaticCreds: true
  destination:
    create: true
    name: payments-orders-db
  refreshAfter: 30s
```
