# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
### Changelog
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
- Set has_issues default value to `false`.

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

<!-- markdown-link-check-disable -->
[Unreleased]: https://github.com/mineiros-io/terraform-github-repository/compare/v0.5.0...HEAD
[0.5.0]: https://github.com/mineiros-io/terraform-github-repository/compare/v0.4.2...v0.5.0
<!-- markdown-link-check-enable -->
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
