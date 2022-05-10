# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.16.2]

### Fixed

- `var.app_installations` should be a of type `set(string)` instead of `set(number)`

## [0.16.1]

### Added

- Add support for `github_app_installation_repository`

## [0.16.0]

### Fixed

- Set correct default value for `delete_branch_on_merge` in docs
- BREAKING CHANGE: Remove support for multi-type variable `branches` (removed `list(string)` support)

## [0.15.0]

### Fixed

- Set correct alternative type for `deploy_keys` in README

### Added

- Add support for `github_branches`

## [0.14.0]

### Added

- Add support for `require_conversation_resolution` for Branch Protection (thanks to @0x46616c6b)
- Add support for `encrypted_secrets`

### Changed

- BREAKING: update to provider `~> 4.20` fixing an issue that was just supporting `v4.19.x`

## [0.13.0]

### Added

- Add GitHub Autolink References configuration block (thanks to @0x46616c6b)

## [0.12.0]

### BREAKING CHANGES

Bumped the minimum supported version of the GitHub Terraform Provider to `v4.19.2`
since it contains a critical bugfix to support `required_approving_review_count = 0`
on branch protection rules. Also, `allow_auto_merge` has been added in `v4.17.0`.

### Added

- Add support for `allow_auto_merge`

## [0.11.0]

### BREAKING CHANGES

We dropped support for Terraform pre 1.0 and GitHub Terraform Provider pre 4.0.
In addition we changed to the `integrations/github` official GitHub Terraform Provider.
This needs migration actions if you already used this module with the `hashicorp/github` provider and want to upgrade.

#### Migration from previous versions

To migrate from a previous version, please ensure that you are using the
`integrations/github` official GitHub Terraform Provider.


``` hcl
terraform {
  required_version = "~> 1.0"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }
  }
}
```

Once you've updated the provider, a manual state migration is required to
migrate existing resources to the new provider.
The following command will replace the provider in the state.

``` bash
terraform state replace-provider registry.terraform.io/hashicorp/github registry.terraform.io/integrations/github
```

After you've migrated the state, please run
`terraform init` to apply the changes to the resources.

### Added

- Add support for Official GitHub Terraform Provider `integrations/github`

### Removed

- Removed support for Terraform < 1.0
- Removed support for GitHub Provider < 4.0
- Removed compatibility to Hashicorp GitHub Terraform Provider `hashicorp/github`

### Fixed

- Set `webhooks` output as sensitive.
- Add underscores in team names (special thanks to @marc-sensenich)
- Fix `dismiss_stale_reviews` in README to a default value of `true`

## [0.10.1]

### Fixed

- Set `vulnerability_alerts` per default to `true` for public repositories and
  to `false` for private repositories if not explicitly set to avoid drifts
  when running `terraform plan`.

## [0.10.0]

### Added

- Add support for Terraform `v1.0`

## [0.9.2]

### Fixed

- Fix terraform typing issue when defining branch protections for multiple branches

## [0.9.1]

### Added

- Add support for GitHub Pages configuration in repositories

## [0.9.0]

### Added

- Add support for Terraform `v0.15`

## [0.8.0]

**_This is a BREAKING RELEASE._**

Branch protection resourcess will be recreated and new fetures are added enforcing security by default.

Please review plans and report regressions and issues asap so we can improve documentation for upgrading.

### Upgrade path/notes:

- Branch protections will be recreated in a compatible way. Alternatively, all branch protections could be manually updated using `terraform state mv` but this is not recommended as it is a manual process that can suffer from human prone errors.
- If you do not want to archive repositories on deletion set `archive_on_destroy` to false in repository configurations.

#### Expected differences in a plan after upgrading:

- Addition to `module.<NAME>.github_repository.repository`:
  - Addition or changed default of argument `archive_on_destroy = true`
- Destruction of `module.<NAME>.github_branch_protection.branch_protection[*]`
- Creation of `module.<NAME>.github_branch_protection_v3.branch_protection[*]`
- Replacement of `module.<NAME>.github_team_repository.team_repository_by_slug[<SLUG>]`
  - Triggered by change in `team_id = "<NUMBER>" -> "<SLUG>"`

### Added

- Add support for Github Provider v4 (Minimal compatible version is v4.5).
- Add support for `archive_on_destroy` repository flag defaulting to `true`.
- Add support for `vulnerability_alerts` repository flag.
- Add security deny list for v4.7.0, v4.8.0, v4.9.0 and v4.9.1 due to a bug setting visibility to public for templated repository creation.

### Changed

- Use [`github_branch_protection_v3`](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_protection_v3) instead of [`github_branch_protection`](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_protection) for performance and compatibility reasons. **ATTENTION**: This Change will trigger recreation of all branch protections when upgrading to v0.8.0.
- Use `github_branch_default` to set default branch of repositories. **ATTENTION**: This Change will trigger creation of new resource when `default_branch` argument is set.

### Removed

- **BREAKING CHANGE**: Removed support for Github Provider before v4.3

## [0.7.0]

### Added

- Add support for `visibility` parameter. Defaults to `private` and respects desired state as defined in deprecated `private` parameter.

### Changed

- Add deprecation of `private` parameter.
- **BREAKING CHANGE:** Minimum Github Terraform Provider version increased to `2.9.0`.

### Added

## [0.6.1]

- Add support for managing github secrets via `plaintext_secrets` argument (#58/#59 kudos to @mrodm)

## [0.6.0]

### Added

- Add support for Terraform v0.14.x

## [0.5.1]

### Fixed

- Remove support for Terraform Github Provider v3.1.0 as this version introduced undocumented breaking changes. See https://github.com/integrations/terraform-provider-github/issues/566 for details.

### Changed

- Adjust default branch in code to github new default branch naming

## [0.5.0]

### Added

- Add support for Terraform v0.13.x
- Add support for Terraform Github Provider v3.x
- Prepare support for Terraform v0.14.x (needs terraform v0.12.20 or above)

## [0.4.2] - 2020-06-23

### Added

- Add `CHANGELOG.md`.

### Changed

- Switch CI from SemaphoreCI to GitHub Actions.

## [0.4.1] - 2020-06-04

### Added

- Add CONTRIBUTING.md.
- Add `phony-targets` and `markdown-link-check` hooks.

### Changed

- Update logo and badges in README.md.

## [0.4.0] - 2020-05-28

### Fixed

- Fix a bug that was introduced during the last release which forced the
  re-creation of teams on every run.

## [0.3.1] - 2020-05-24

### Fixed

- Fix dependency issue when assigning teams by name.

## [0.3.0] - 2020-05-14

### Added

- Add `issue_labels_create` to specify whether you want to force or suppress the
  creation of issues labels. Default is `true` if `has_issues` is `true` or
  `issue_labels` is non-empty, otherwise default is `false`.

## [0.2.1] - 2020-05-09

### Added

- Introduced support for the
  [github_repository_webhook](https://www.terraform.io/docs/providers/github/r/repository_webhook.html)
  resource. You can now add webhooks to your repositories through the newly
  introduced variable `webhooks`. For further information please read the
  [documentation](https://github.com/mineiros-io/terraform-github-repository#webhooks-configuration).

## [0.2.0] - 2020-04-16

### Added

- Use slugs for team ids.

### Changed

- Set `delete_branch_on_merge` default value to `true`.
- Upgrade terraform-github-provider to `~> 2.6`.

### Fixed

- Fix module dependency by introducing `modules_depends_on`.

## [0.1.0] - 2020-02-27

### Changed

- Update README.md and add more examples and related tests.

## [0.0.7] - 2020-01-14

### Changed

- Breaking Changes for `branch_protection_rules`. Properties are now configured
  as a nested object instead of lists.

## [0.0.6] - 2020-01-12

### Changed

- Ignore changes in `auto_init`.
- Ignore changes in `gitignore_template`.
- Ignore changes in `license_template`.

## [0.0.5] - 2020-01-12

### Added

- Add `defaults`.
- Add `extra_topics` for adding additional topics when defaults.topics should
  not be overwritten but merged.
- Add `admin_collaborators` as a list of github usernames to add as
  collaborators with admin permission.
- Add `push_collaborators` as a list of github usernames to add as collaborators
  with push permission.
- Add `pull_collaborators` as a list of github usernames to add as collaborators
  with pull permission.
- Add `admin_team_ids` as a list of team IDs to add as admin teams.
- Add `push_team_ids` as a list of team IDs to add as push teams.
- Add `pull_team_ids` as a list of team IDs to add as pull teams.

### Changed

- Use `for_each` instead of `count` to not recreate most resources when order
  in module parameter changes.
- Add automated unit tests.

### Fixed

- Fix race condition in `branch_protection` configuration.

### Removed

- Remove `teams`.
- Remove `collaborators`.

## [0.0.4] - 2020-01-06

### Changed

- Set `auto_init` default value to `true`.

## [0.0.3] - 2020-01-06

### Changed

- Set `has_issues` default value to `false`.

## [0.0.2] - 2020-01-06

### Removed

- Remove unnecessary `Vars` declaration from test.

### Changed

- Set `has_feature` toggles default values to `false`.
- Set example variables default value to null.

## [0.0.1] - 2020-01-05

### Added

- This is the initial release of our GitHub Repository module with support for
  creating and managing GitHub Repositories for Organizations.

[unreleased]: https://github.com/mineiros-io/terraform-github-repository/compare/v0.16.2...HEAD
[0.16.2]: https://github.com/mineiros-io/terraform-github-repository/compare/v0.16.1...v0.16.2
[0.16.1]: https://github.com/mineiros-io/terraform-github-repository/compare/v0.16.0...v0.16.1
[0.16.0]: https://github.com/mineiros-io/terraform-github-repository/compare/v0.15.0...v0.16.0
[0.15.0]: https://github.com/mineiros-io/terraform-github-repository/compare/v0.14.0...v0.15.0
[0.14.0]: https://github.com/mineiros-io/terraform-github-repository/compare/v0.13.0...v0.14.0
[0.13.0]: https://github.com/mineiros-io/terraform-github-repository/compare/v0.12.0...v0.13.0
[0.12.0]: https://github.com/mineiros-io/terraform-github-repository/compare/v0.11.0...v0.12.0
[0.11.0]: https://github.com/mineiros-io/terraform-github-repository/compare/v0.10.1...v0.11.0
[0.10.1]: https://github.com/mineiros-io/terraform-github-repository/compare/v0.10.0...v0.10.1
[0.10.0]: https://github.com/mineiros-io/terraform-github-repository/compare/v0.9.2...v0.10.0
[0.9.2]: https://github.com/mineiros-io/terraform-github-repository/compare/v0.9.1...v0.9.2
[0.9.1]: https://github.com/mineiros-io/terraform-github-repository/compare/v0.9.0...v0.9.1
[0.9.0]: https://github.com/mineiros-io/terraform-github-repository/compare/v0.8.0...v0.9.0
[0.8.0]: https://github.com/mineiros-io/terraform-github-repository/compare/v0.7.0...v0.8.0
[0.7.0]: https://github.com/mineiros-io/terraform-github-repository/compare/v0.6.1...v0.7.0
[0.6.1]: https://github.com/mineiros-io/terraform-github-repository/compare/v0.6.0...v0.6.1
[0.6.0]: https://github.com/mineiros-io/terraform-github-repository/compare/v0.5.1...v0.6.0
[0.5.1]: https://github.com/mineiros-io/terraform-github-repository/compare/v0.5.0...v0.5.1
[0.5.0]: https://github.com/mineiros-io/terraform-github-repository/compare/v0.4.2...v0.5.0
[0.4.2]: https://github.com/mineiros-io/terraform-github-repository/compare/v0.4.1...v0.4.2
[0.4.1]: https://github.com/mineiros-io/terraform-github-repository/compare/v0.4.0...v0.4.1
[0.4.0]: https://github.com/mineiros-io/terraform-github-repository/compare/v0.3.1...v0.4.0
[0.3.1]: https://github.com/mineiros-io/terraform-github-repository/compare/v0.3.0...v0.3.1
[0.3.0]: https://github.com/mineiros-io/terraform-github-repository/compare/v0.2.1...v0.3.0
[0.2.1]: https://github.com/mineiros-io/terraform-github-repository/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/mineiros-io/terraform-github-repository/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/mineiros-io/terraform-github-repository/compare/v0.0.7...v0.1.0
[0.0.7]: https://github.com/mineiros-io/terraform-github-repository/compare/v0.0.6...v0.0.7
[0.0.6]: https://github.com/mineiros-io/terraform-github-repository/compare/v0.0.5...v0.0.6
[0.0.5]: https://github.com/mineiros-io/terraform-github-repository/compare/v0.0.4...v0.0.5
[0.0.4]: https://github.com/mineiros-io/terraform-github-repository/compare/v0.0.3...v0.0.4
[0.0.3]: https://github.com/mineiros-io/terraform-github-repository/compare/v0.0.2...v0.0.3
[0.0.2]: https://github.com/mineiros-io/terraform-github-repository/compare/v0.0.1...v0.0.2
[0.0.1]: https://github.com/mineiros-io/terraform-aws-s3-bucket/releases/tag/v0.0.1
