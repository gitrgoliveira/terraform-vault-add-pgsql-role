mock_provider "vault" {}

run "invalid_usecase_name_fails_validation" {
  command = plan

  variables {
    cluster_name       = "dev-cluster"
    db_connection_name = "appdb"
    db_mount_path      = "db/dev-cluster/appdb"
    db_username        = "app_user"
    usecase_name       = "INVALID_NAME"
    workload_name      = "apps"
  }

  expect_failures = [
    var.usecase_name,
  ]
}

run "invalid_cluster_name_fails_validation" {
  command = plan

  variables {
    cluster_name       = "-bad"
    db_connection_name = "appdb"
    db_mount_path      = "db/dev-cluster/appdb"
    db_username        = "app_user"
    usecase_name       = "payments"
    workload_name      = "apps"
  }

  expect_failures = [
    var.cluster_name,
  ]
}

run "invalid_workload_name_fails_validation" {
  command = plan

  variables {
    cluster_name       = "dev-cluster"
    db_connection_name = "appdb"
    db_mount_path      = "db/dev-cluster/appdb"
    db_username        = "app_user"
    usecase_name       = "payments"
    workload_name      = "INVALID_NAME"
  }

  expect_failures = [
    var.workload_name,
  ]
}

run "injection_in_db_mount_path_fails_validation" {
  command = plan

  variables {
    cluster_name       = "dev-cluster"
    db_connection_name = "appdb"
    db_username        = "app_user"
    usecase_name       = "payments"
    workload_name      = "apps"
    # Breakout chars (quote, brace, space) must be rejected so db_mount_path
    # cannot terminate the static-creds policy path block.
    db_mount_path = "db/appdb\" {x}"
  }

  expect_failures = [
    var.db_mount_path,
  ]
}
