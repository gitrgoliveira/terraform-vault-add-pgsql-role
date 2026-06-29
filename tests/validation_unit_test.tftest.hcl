mock_provider "vault" {}

run "invalid_usecase_name_fails_validation" {
  command = plan

  variables {
    auth_role_name     = "dev-cluster-apps"
    cluster_name       = "dev-cluster"
    db_connection_name = "appdb"
    db_mount_path      = "db/dev-cluster/appdb"
    db_username        = "app_user"
    entity_id          = "entity-123"
    jwt_auth_path      = "jwt/dev-cluster"
    principal_name     = "apps"
    usecase_name       = "INVALID_NAME"
  }

  expect_failures = [
    var.usecase_name,
  ]
}

run "invalid_cluster_name_fails_validation" {
  command = plan

  variables {
    auth_role_name     = "dev-cluster-apps"
    cluster_name       = "-bad"
    db_connection_name = "appdb"
    db_mount_path      = "db/dev-cluster/appdb"
    db_username        = "app_user"
    entity_id          = "entity-123"
    jwt_auth_path      = "jwt/dev-cluster"
    principal_name     = "apps"
    usecase_name       = "payments"
  }

  expect_failures = [
    var.cluster_name,
  ]
}

run "injection_in_db_mount_path_fails_validation" {
  command = plan

  variables {
    auth_role_name     = "dev-cluster-apps"
    cluster_name       = "dev-cluster"
    db_connection_name = "appdb"
    db_username        = "app_user"
    entity_id          = "entity-123"
    jwt_auth_path      = "jwt/dev-cluster"
    principal_name     = "apps"
    usecase_name       = "payments"
    # Breakout chars (quote, brace, space) must be rejected so db_mount_path
    # cannot terminate the static-creds policy path block.
    db_mount_path = "db/appdb\" {x}"
  }

  expect_failures = [
    var.db_mount_path,
  ]
}
