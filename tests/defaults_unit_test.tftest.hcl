mock_provider "vault" {}

run "defaults_plan_succeeds" {
  command = plan

  variables {
    cluster_name       = "dev-cluster"
    db_connection_name = "appdb"
    db_mount_path      = "db/dev-cluster/appdb"
    db_username        = "app_user"
    usecase_name       = "payments"
    workload_name      = "apps"
  }

  assert {
    condition     = output.db_role_name == "dev-cluster-apps-payments-pg"
    error_message = "db_role_name should match naming convention."
  }

  assert {
    condition     = output.policy_name == "dev-cluster-apps-payments-db-read"
    error_message = "policy_name should match naming convention."
  }

  assert {
    condition     = output.group_name == "dev-cluster-apps-payments-db"
    error_message = "group_name should match naming convention."
  }

  assert {
    condition     = strcontains(output.injector_yaml, "static-creds/dev-cluster-apps-payments-pg")
    error_message = "injector_yaml should reference static-creds path for computed role name."
  }

  assert {
    condition     = strcontains(output.injector_yaml, "auth-config-path: \"/var/run/secrets/vault.hashicorp.com/serviceaccount/token\"")
    error_message = "injector_yaml must point Vault Agent's JWT method at the projected token (it fails without 'path')."
  }

  assert {
    condition     = strcontains(output.injector_yaml, "agent-service-account-token-volume-name: \"vault-token\"")
    error_message = "the injector must mount the projected token volume, or auth-config-path points at nothing."
  }

  assert {
    condition     = strcontains(output.vso_yaml, "allowStaticCreds: true")
    error_message = "vso_yaml must allow static creds; VSO otherwise treats static-creds/ as a leased secret."
  }

  assert {
    condition     = strcontains(output.vso_yaml, "audiences:\n      - vault")
    error_message = "the VaultAuth must request a token with the workload role's bound audience."
  }
}
