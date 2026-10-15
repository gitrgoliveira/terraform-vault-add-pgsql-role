# Changelog

All notable changes to this project are documented in this file.

## [0.4.2] - 2026-10-15

### Fixed

- The Vault Agent Injector annotations now authenticate with the JWT method as rendered: they mount a projected ServiceAccount token (`agent-service-account-token-volume-name`), point the method at it with `auth-config-path` (Vault Agent fails with `missing 'path' value` without it), and keep the file (`auth-config-remove-jwt-after-reading: "false"`). A comment in the snippet shows the pod volume to add, with audience `vault`.
- The VSO `VaultAuth` now requests a ServiceAccount token with audience `vault` (`jwt.audiences`). VSO sets no default audience, so the token carried the API server audience and failed the workload role's `bound_audiences`.
- The `vso_yaml` `VaultDynamicSecret` sets `allowStaticCreds: true`, which VSO requires to sync a rotated `static-creds/` path.

## [0.4.1] - 2026-07-29

### Fixed

- The `injector_yaml` README example now includes the `vault.hashicorp.com/auth-type: "jwt"` annotation that the rendered template emits; without it the Vault Agent Injector defaults to token auth.

## [0.4.0] - 2026-07-24

### Changed
- BREAKING: removed `entity_id` input variable. The workload entity is now discovered automatically via a `vault_identity_entity` data source using the naming convention `<cluster_name>-<workload_name>`. The workload module must be applied first. No-code form reduced from 8 to 7 fields.

## [0.3.0] - 2026-07-24

### Changed
- BREAKING: removed 6 render-only variables (`auth_role_name`, `jwt_auth_path`, `vault_address`, `vault_namespace`, `k8s_namespace`, `k8s_service_account`). `auth_role_name` and `jwt_auth_path` are now derived in locals; the remaining 4 are replaced by placeholders in templates. No-code form reduced from 14 to 8 fields.

## [0.2.0] - 2026-07-24

### Added
- Validation block for `db_connection_name` using the standard identifier regex.
- Negative validation test for `workload_name` in unit tests.

### Fixed
- README injector annotations example now shows the correct `auth/` prefix on `vault.hashicorp.com/auth-path`.
- `vso_yaml` output description updated to mention both VaultAuth and VaultDynamicSecret resources.

## [0.1.0] - 2026-07-07

### Changed
- BREAKING: renamed the `principal_name` input to `workload_name` to align with the "workload" onboarding terminology. Consumers must update the input name.

## [0.0.2] - 2026-06-29

### Changed
- Documentation and version-consistency fixes: corrected the no-code registry pin, the registry-usage version constraint, and the CHANGELOG release header.

## [0.0.1]

### Added
- Initial no-code-ready module implementation.
