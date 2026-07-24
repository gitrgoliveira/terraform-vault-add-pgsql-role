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
}
