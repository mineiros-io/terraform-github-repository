[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>][homepage]

[![Build Status][badge-build]][build-status]
[![GitHub tag (latest SemVer)][badge-semver]][releases-github]
[![Terraform Version][badge-terraform]][releases-terraform]
[![Github Provider Version][badge-tf-gh]][releases-github-provider]
[![Join Slack][badge-slack]][slack]

# terraform-github-repository

A [Terraform] module for creating a public or private repository on [Github].

**_This module supports Terraform v1.x and is compatible with the Official Terraform GitHub Provider v4.10 and above from `integrations/github`._**

**Attention: This module is incompatible with the Hashicorp GitHub Provider! The latest version of this module supporting `hashicorp/github` provider is `~> 0.10.0`**

_Security related notice: Versions 4.7.0, 4.8.0, 4.9.0 and 4.9.1 of the Terraform Github Provider are deny-listed in version constraints as a regression introduced in 4.7.0 and fixed in 4.9.2 creates public repositories from templates even if visibility is set to private._

- [Module Features](#module-features)
- [Getting Started](#getting-started)
- [Module Argument Reference](#module-argument-reference)
  - [Top-level Arguments](#top-level-arguments)
    - [Module Configuration](#module-configuration)
    - [Repository Configuration](#repository-configuration)
    - [Repository Creation Configuration](#repository-creation-configuration)
    - [Teams Configuration](#teams-configuration)
    - [Collaborator Configuration](#collaborator-configuration)
    - [Deploy Keys Configuration](#deploy-keys-configuration)
    - [Branch Protections Configuration](#branch-protections-configuration)
    - [Issue Labels Configuration](#issue-labels-configuration)
    - [Projects Configuration](#projects-configuration)
    - [Webhooks Configuration](#webhooks-configuration)
    - [Secrets Configuration](#secrets-configuration)
    - [`defaults` Object Attributes](#defaults-object-attributes)
    - [`template` Object Attributes](#template-object-attributes)
    - [`pages` Object Attributes](#pages-object-attributes)
    - [`deploy_key` Object Attributes](#deploy_key-object-attributes)
    - [`branch_protection` Object Attributes](#branch_protection-object-attributes)
      - [`required_status_checks` Object Attributes](#required_status_checks-object-attributes)
      - [`required_pull_request_reviews` Object Attributes](#required_pull_request_reviews-object-attributes)
      - [`restrictions` Object Attributes](#restrictions-object-attributes)
    - [`issue_label` Object Attributes](#issue_label-object-attributes)
    - [`project` Object Attributes](#project-object-attributes)
    - [`webhook` Object Attributes](#webhook-object-attributes)
- [Module Attributes Reference](#module-attributes-reference)
- [External Documentation](#external-documentation)
- [Module Versioning](#module-versioning)
  - [Backwards compatibility in `0.0.z` and `0.y.z` version](#backwards-compatibility-in-00z-and-0yz-version)
- [About Mineiros](#about-mineiros)
- [Reporting Issues](#reporting-issues)
- [Contributing](#contributing)
- [Makefile Targets](#makefile-targets)
- [License](#license)

## Module Features

In contrast to the plain `github_repository` resource this module enables various other
features like Branch Protection or Collaborator Management.

- **Default Security Settings**:
  This module creates a `private` repository by default,
  Deploy keys are `read-only` by default

- **Standard Repository Features**:
  Setting basic Metadata,
  Merge Strategy,
  Auto Init,
  License Template,
  Gitignore Template,
  Template Repository

- **Extended Repository Features**:
  Branch Protection,
  Issue Labels,
  Handle Github Default Issue Labels,
  Collaborators,
  Teams,
  Deploy Keys,
  Projects,
  Repository Webhooks

- _Features not yet implemented_:
  Project Columns support,
  Actions,
  Repository File

## Getting Started

Most basic usage creating a new private github repository.

```hcl
module "repository" {
  source  = "mineiros-io/repository/github"
  version = "~> 0.10.0"

  name               = "terraform-github-repository"
  license_template   = "apache-2.0"
  gitignore_template = "Terraform"
}

provider "github" {}

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

## Module Argument Reference

See [variables.tf] and [examples/] for details and use-cases.

### Top-level Arguments

#### Module Configuration

- **`module_depends_on`**: _(Optional `list(any)`)_

  Due to the fact, that terraform does not offer `depends_on` on modules as of today (v0.12.24)
  we might hit race conditions when dealing with team names instead of ids.
  So when using the feature of [adding teams by slug/name](#teams-configuration) to the repository when creating it,
  make sure to add all teams to this list as indirect dependencies.
  Default is `[]`.

#### Repository Configuration

- **`name`**: **_(Required `string`)_**

  The name of the repository.

- **[`defaults`](#defaults-object-attributes)**: _(Optional `object`)_

  A object of default settings to use instead of module defaults for top-level arguments.
  See below for a list of supported arguments.
  Default is `{}` - use module defaults as described in the README.

- **[`pages`](#pages-object-attributes)**: _(Optional `object`)_

  A object of settings to configure GitHub Pages in this repository.
  See below for a list of supported arguments.
  Default is `null`.

- **`allow_merge_commit`**: _(Optional `bool`)_

  Set to `false` to disable merge commits on the repository.
  If you set this to `false` you have to enable either `allow_squash_merge`
  or `allow_rebase_merge`.
  Default is `true`.

- **`allow_squash_merge`**: _(Optional `bool`)_

  Set to `true` to enable squash merges on the repository.
  Default is `false`.

- **`allow_rebase_merge`**: _(Optional `bool`)_

  Set to `true` to enable rebase merges on the repository.
  Default is `false`.

- **`description`**: _(Optional `string`)_

  A description of the repository.
  Default is `""`.

- **`delete_branch_on_merge`**: _(Optional `string`)_

  Set to `false` to disable the automatic deletion of head branches after pull requests are merged.
  Default is `true`.

- **`homepage_url`**: _(Optional `string`)_

  URL of a page describing the project.
  Default is `""`.

- ~`private`~: _(Optional `bool`)_

  **_DEPRECATED_**: Please use `visibility` instead and update your code. parameter will be removed in a future version

- **`visibility`**: _(Optional `string`)_

  Can be `public` or `private`.
  If your organization is associated with an enterprise account using GitHub Enterprise Cloud or GitHub Enterprise Server 2.20+, `visibility` can also be `internal`.
  The `visibility` parameter overrides the deprecated `private` parameter.
  Default is `private`.
  If the deprecated `private` boolean parameter is used, the default value is adjusted to respect this setting.

- **`has_issues`**: _(Optional `bool`)_

  Set to true to enable the GitHub Issues features on the repository.
  Default is `false`

- **`has_projects`**: _(Optional `bool`)_

  Set to true to enable the GitHub Projects features on the repository.
  Default is `false`

- **`has_wiki`**: _(Optional `bool`)_

  Set to true to enable the GitHub Wiki features on the repository.
  Default is `false`

- **`has_downloads`**: _(Optional `bool`)_

  Set to `true` to enable the (deprecated) downloads features on the repository.
  Default is `false`.

- **`is_template`**: _(Optional `bool`)_

  Set to `true` to tell GitHub that this is a template repository.
  Default is `false`.

- **`default_branch`**: _(Optional `string`)_

  The name of the default branch of the repository.
  NOTE: This can only be set after a repository has already been created, and
  after a correct reference has been created for the target branch inside the repository.
  This means a user will have to omit this parameter from the initial repository creation and
  create the target branch inside of the repository prior to setting this attribute.
  Default is `""`.

- **`archived`**: _(Optional `bool`)_

  Specifies if the repository should be archived.
  NOTE: Currently, the API does not support unarchiving.
  Default is `false`.

- **`topics`**: _(Optional `list(string)`)_

  The list of topics of the repository.
  Default is `[]`.

- **`extra_topics`**: _(Optional `list(string)`)_

  A list of additional topics of the repository. Those topics will be added to
  the list of `topics`. This is useful if `default.topics` are used and the list
  should be extended with more topics.
  Default is `[]`.

- **`vulnerability_alerts`**: _(Optional `bool`)_

  Set to `false` to disable security alerts for vulnerable dependencies.
  Enabling requires alerts to be enabled on the owner level.

- **`archive_on_destroy`**: _(Optional `bool`)_

  Set to `false` to not archive the repository instead of deleting on destroy.

#### Repository Creation Configuration

The following four arguments can only be set at repository creation and
changes will be ignored for repository updates and
will not show a diff in plan or apply phase.

- **`auto_init`**: _(Optional `bool`)_

  Set to `false` to not produce an initial commit in the repository.
  Default is `true`.

- **`gitignore_template`**: _(Optional `string`)_

  Use the name of the template without the extension.
  Default is `""`

- **`license_template`**: _(Optional `string`)_

  Use the name of the template without the extension.
  Default is `""`

- **[`template`](#template-object-attributes)**: _(Optional `object`)_

  Use a template repository to create this resource.
  See [Template Object Attributes](#template-object-attributes) below for details.

#### Teams Configuration

Your can use non-computed
(known at `terraform plan`) team names or slugs
(`*_teams` Attributes)
or computed (only known in `terraform apply` phase) team IDs
(`*_team_ids` Attributes).
**When using non-computed names/slugs teams need to exist before running plan.**
This is due to some terraform limitation and we will update the module once terraform
removed thislimitation.

- **`pull_teams`** or **`pull_team_ids`**: _(Optional `list(string)`)_

  A list of teams to grant pull (read-only) permission.
  Recommended for non-code contributors who want to view or discuss your project.
  Default is `[]`.

- **`triage_teams`** or **`triage_team_ids`**: _(Optional `list(string)`)_

  A list of teams to grant triage permission.
  Recommended for contributors who need to proactively manage issues and pull requests
  without write access.
  Default is `[]`.

- **`push_teams`** or **`push_team_ids`**: _(Optional `list(string)`)_

  A list of teams to grant push (read-write) permission.
  Recommended for contributors who actively push to your project.
  Default is `[]`.

- **`maintain_teams`** or **`maintain_team_ids`**: _(Optional `list(string)`)_

  A list of teams to grant maintain permission.
  Recommended for project managers who need to manage the repository without access
  to sensitive or destructive actions.
  Default is `[]`.

- **`admin_teams`** or **`admin_team_ids`**: _(Optional `list(string)`)_

  A list of teams to grant admin (full) permission.
  Recommended for people who need full access to the project, including sensitive
  and destructive actions like managing security or deleting a repository.
  Default is `[]`.

#### Collaborator Configuration

- **`pull_collaborators`**: _(Optional `list(string)`)_

  A list of user names to add as collaborators granting them pull (read-only) permission.
  Recommended for non-code contributors who want to view or discuss your project.
  Default is `[]`.

- **`triage_collaborators`**: _(Optional `list(string)`)_

  A list of user names to add as collaborators granting them triage permission.
  Recommended for contributors who need to proactively manage issues and pull requests
  without write access.
  Default is `[]`.

- **`push_collaborators`**: _(Optional `list(string)`)_

  A list of user names to add as collaborators granting them push (read-write) permission.
  Recommended for contributors who actively push to your project.
  Default is `[]`.

- **`maintain_collaborators`**: _(Optional `list(string)`)_

  A list of user names to add as collaborators granting them maintain permission.
  Recommended for project managers who need to manage the repository without access
  to sensitive or destructive actions.
  Default is `[]`.

- **`admin_collaborators`**: _(Optional `list(string)`)_

  A list of user names to add as collaborators granting them admin (full) permission.
  Recommended for people who need full access to the project, including sensitive
  and destructive actions like managing security or deleting a repository.
  Default is `[]`.

#### Deploy Keys Configuration

- **[`deploy_keys`](#deploy_key-object-attributes)**: _(Optional `list(deploy_key|string)`)_

  Specifies deploy keys and access-level of deploy keys used in this repository.
  Every `string` in the list will be converted internally into the `object`
  representation with the `key` argument being set to the `string`.
  `object` details are explained below.
  Default is `[]`.

- **[`deploy_keys_computed`](#deploy_key-object-attributes)**: _(Optional `list(deploy_key|string)`)_

  Same as `deploy_keys` argument with the following differences:
  Use this argument if you depend on computed keys that terraform can not use in
  resource `for_each` execution. Downside of this is the recreation of deploy key
  resources whenever the order in the list changes. **Prefer `deploy_keys` whenever possible.**
  This argument does **not** conflict with `deploy_keys` and should exclusively be
  used for computed resources.
  Default is `[]`.

#### Branch Protections Configuration

- **[`branch_protections_v3`](#branch_protection-object-attributes)**: _(Optional `list(branch_protection)`)_

  This resource allows you to configure branch protection for repositories in your organization.
  When applied, the branch will be protected from forced pushes and deletion.
  Additional constraints, such as required status checks or restrictions on users and teams,
  can also be configured.
  Default is `[]` unless `branch_protections` is used.

- **[`branch_protections`](#branch_protection-object-attributes)**: **_(DEPRECATED)_**

  **_DEPRECATED_** To ensure compatibility with future versions of this module, please use `branch_protections_v3`.
  This argument is ignored if `branch_protections_v3` is used.
  Default is `[]`.

#### Issue Labels Configuration

- **[`issue_labels`](#issue_label-object-attributes)**: _(Optional `list(issue_label)`)_

  This resource allows you to create and manage issue labels within your GitHub organization.
  Issue labels are keyed off of their "name", so pre-existing issue labels result
  in a 422 HTTP error if they exist outside of Terraform.
  Normally this would not be an issue, except new repositories are created with a
  "default" set of labels, and those labels easily conflict with custom ones.
  This resource will first check if the label exists, and then issue an update,
  otherwise it will create.
  Default is `[]`.

- **[`issue_labels_merge_with_github_labels`](#issue_label-object-attributes)**: _(Optional `bool`)_

  Specify if github default labels will be handled by terraform. This should be decided on upon creation of the repository. If you later decide to disable this feature, github default labels will be destroyed if not
  replaced by labels set in `issue_labels` argument.
  Default is `true`.

- **[`issue_labels_create`](#issue_label-object-attributes)**: _(Optional `bool`)_

  Specify whether you want to force or suppress the creation of issues labels.
  Default is `true` if `has_issues` is `true` or `issue_labels` is non-empty, otherwise default is `false`.

#### Projects Configuration

- **[`projects`](#project-object-attributes)**: _(Optional `list(project)`)_

  This resource allows you to create and manage projects for GitHub repository.
  Default is `[]`.

#### Webhooks Configuration

- **[`webhooks`](#webhook-object-attributes)**: _(Optional `list(webhook)`)_

  This resource allows you to create and manage webhooks for repositories in your organization.
  When applied, a webhook will be created which specifies a URL to receive events and which events
  to receieve. Additional constraints, such as SSL verification, pre-shared secret and content type
  can also be configured
  Default is `[]`.

#### Secrets Configuration

- **`plaintext_secrets`**: _(Optional `map(string)`)_

  This map allows you to create and manage secrets for repositories in your organization.
  Each element in the map is considered a secret to be managed, being the key map the secret name and the value the corresponding secret in plain text:

  ```
  plaintext_secrets = {
    SECRET_NAME_1 = "secret_value_1"
    SECRET_NAME_2 = "secret_value_2"
    ...
  }
  ```

  When applied, a secret with the given key and value will be created in the repositories.
  The value of the secrets must be given in plain text, github provider is in charge of encrypting it.
  **Attention:** You might want to get secrets via a data source from a secure vault and not add them in plain text to your source files; so you do not commit plaintext secrets into the git repository managing your github account.
  Default is `{}`.

#### [`defaults`](#repository-configuration) Object Attributes

This is a special argument to set various defaults to be reused for multiple repositories.
The following top-level arguments can be set as defaults:
`homepage_url`,
`visibility`,
`has_issues`,
`has_projects`,
`has_wiki`,
`allow_merge_commit`,
`allow_rebase_merge`,
`allow_squash_merge`,
`has_downloads`,
`auto_init`,
`gitignore_template`,
`license_template`,
`default_branch`,
`topics`,
`issue_labels_create`,
`issue_labels_merge_with_github_labels`.
Module defaults are used for all arguments that are not set in `defaults`.
Using top level arguments override defaults set by this argument.
Default is `{}`.

#### [`pages`](#pages-object-attributes) Object Attributes

This block is used for configuring GitHub Pages for the repository.
The following top-level arguments must be set to configure GitHub Pages for
the repository:

- **`branch`**: **_(Required `string`)_**

  The repository branch used to publish the site's source files.

- **`path`**: **_(Optional `string`)_**

  The repository directory from which the site publishes.

- **`cname`**: **_(Optional `string`)_**

  The custom domain for the repository. This can only be set after the
  repository has been created.
  Default is `null`.

#### [`template`](#repository-creation-configuration) Object Attributes

- **`owner`**: **_(Required `string`)_**

  The GitHub organization or user the template repository is owned by.

- **`repository`**: **_(Required `string`)_**

  The name of the template repository.

#### [`deploy_key`](#deploy-keys-configuration) Object Attributes

- **`key`**: **_(Required `string`)_**

  The SSH public key.

- **`title`**: _(Optional `string`)_

  A Title for the key.
  Default is the comment field of SSH public key if it is not empty else it defaults to
  `md5(key)`.

- **`read_only`**: _(Optional `bool`)_

  Specifies the level of access for the key.
  Default is `true`.

- **`id`**: _(Optional `string`)_

  Specifies an ID which is used to prevent resource recreation when the order in
  the list of deploy keys changes.
  The ID must be unique between `deploy_keys` and `deploy_keys_computed`.
  Default is `md5(key)`.

#### [`branch_protection`](#branch-protections-configuration) Object Attributes

- **`branch`**: **_(Required `string`)_**

  The Git branch to protect.

- **`enforce_admins`**: _(Optional `bool`)_

  Setting this to true enforces status checks for repository administrators.
  Default is `false`.

- **`require_signed_commits`**: _(Optional `bool`)_

  Setting this to true requires all commits to be signed with GPG.
  Default is `false`.

- **`required_status_checks`**: _(Optional `required_status_checks`)_

  Enforce restrictions for required status checks.
  See Required Status Checks below for details.
  Default is `{}`.

- **`required_pull_request_reviews`**: _(Optional `required_pull_request_reviews`)_

  Enforce restrictions for pull request reviews.
  See Required Pull Request Reviews below for details.
  Default is `{}`.

- **`restrictions`**: _(Optional `restrictions`)_

  Enforce restrictions for the users and teams that may push to the branch -
  only available for organization-owned repositories. See Restrictions below for details.
  Default is `{}`.

##### [`required_status_checks`](#branch_protection-object-attributes) Object Attributes

- **`strict`**: _(Optional `bool`)_

  Require branches to be up to date before merging.
  Defaults is `false`.

- **`contexts`**: _(Optional `list(string)`)_

  The list of status checks to require in order to merge into this branch.
  Default is `[]` - No status checks are required.

##### [`required_pull_request_reviews`](#branch_protection-object-attributes) Object Attributes

- **`dismiss_stale_reviews`**: _(Optional `bool`)_

  Dismiss approved reviews automatically when a new commit is pushed.
  Default is `true`.

- **`dismissal_users`**: _(Optional `list(string)`)_

  The list of user logins with dismissal access
  Default is `[]`.

- **`dismissal_teams`**: _(Optional `list(string)`)_

  The list of team slugs with dismissal access.
  Always use slug of the team, not its name.
  Each team already has to have access to the repository.
  Default is `[]`.

- **`require_code_owner_reviews`**: _(Optional `bool`)_

  Require an approved review in pull requests including files with a designated code owner.
  Defaults is `false`.

- **`required_approving_review_count`**: _(Optional `number`)_

  Require x number of approvals to satisfy branch protection requirements.
  If this is specified it must be a number between 1-6.
  This requirement matches Github's API, see the upstream documentation for more information.
  Default is no approving reviews are required.

##### [`restrictions`](#branch_protection-object-attributes) Object Attributes

- **`users`**: _(Optional `list(string)`)_

  The list of user logins with push access.
  Default is `[]`.

- **`teams`**: _(Optional `list(string)`)_

  The list of team slugs with push access.
  Always use slug of the team, not its name.
  Each team already has to have access to the repository.
  Default is `[]`.

- **`apps`**: _(Optional `list(string)`)_

  The list of app slugs with push access.
  Default is `[]`.

#### [`issue_label`](#issue-labels-configuration) Object Attributes

- **`name`**: **_(Required `string`)_**

  The name of the label.

- **`color`**: **_(Required `string`)_**

  A 6 character hex code, without the leading #, identifying the color of the label.

- **`description`**: _(Optional `string`)_

  A short description of the label.
  Default is `""`.

- **`id`**: _(Optional `string`)_

  Specifies an ID which is used to prevent resource recreation when the order in
  the list of issue labels changes.
  Default is `name`.

#### [`project`](#projects-configuration) Object Attributes

- **`name`**: **_(Required `string`)_**

  The name of the project.

- **`body`**: _(Optional `string`)_

  The body of the project.
  Default is `""`.

- **`id`**: _(Optional `string`)_

  Specifies an ID which is used to prevent resource recreation when the order in
  the list of projects changes.
  Default is `name`.

#### [`webhook`](#webhooks-configuration) Object Attributes

- **`events`**: **_(Required `list(string)`)_**

  A list of events which should trigger the webhook. [See a list of available events.](https://developer.github.com/v3/activity/events/types/)

- **`url`**: **_(Required `string`)_**

  The URL to which the payloads will be delivered.

- **`active`**: _(Optional `bool`)_

  Indicate if the webhook should receive events. Defaults to `true`.

- **`content_type`**: _(Optional `string`)_

  The media type used to serialize the payloads. Supported values include `json` and `form`. The default is `form`.

- **`secret`**: _(Optional `string`)_

  If provided, the `secret` will be used as the `key` to generate the HMAC hex digest value in the `[X-Hub-Signature](https://developer.github.com/webhooks/#delivery-headers)` header.

- **`insecure_ssl`**: _(Optional `bool`)_

  Determines whether the SSL certificate of the host for `url` will be verified when delivering payloads. Supported values include `0` (verification is performed) and `1` (verification is not performed). The default is `0`. **We strongly recommend not setting this to `1` as you are subject to man-in-the-middle and other attacks.**

## Module Attributes Reference

The following attributes are exported by the module:

- **`repository`**

  All repository attributes as returned by the
  [`github_repository`] resource
  containing all arguments as specified above and the other attributes as specified below.

  - **`full_name`**

    A string of the form "orgname/reponame".

  - **`html_url`**

    URL to the repository on the web.

  - **`ssh_clone_url`**

    URL that can be provided to git clone to clone the repository via SSH.

  - **`http_clone_url`**

    URL that can be provided to git clone to clone the repository via HTTPS.

  - **`git_clone_url`**

    URL that can be provided to git clone to clone the repository anonymously via the git protocol.

- **`collaborators`**

  A map of Collaborator objects keyed by the `name` of the collaborator as returned by the
  [`github_repository_collaborator`] resource.

- **`deploy_keys`**

  A merged map of deploy key objects for the keys originally passed via `deploy_keys` and
  `deploy_keys_computed` as returned by the [`github_repository_deploy_key`] resource
  keyed by the input `id` of the key.

- **`projects`**

  A map of Project objects keyed by the `id` of the project as returned by the
  [`github_repository_project`] resource

## External Documentation

- Terraform Github Provider Documentation:
  - https://www.terraform.io/docs/providers/github/r/repository.html
  - https://www.terraform.io/docs/providers/github/r/repository_collaborator.html
  - https://www.terraform.io/docs/providers/github/r/repository_deploy_key.html
  - https://www.terraform.io/docs/providers/github/r/repository_project.html

## Module Versioning

This Module follows the principles of [Semantic Versioning (SemVer)].

Given a version number `MAJOR.MINOR.PATCH`, we increment the:

1. `MAJOR` version when we make incompatible changes,
2. `MINOR` version when we add functionality in a backwards compatible manner, and
3. `PATCH` version when we make backwards compatible bug fixes.

### Backwards compatibility in `0.0.z` and `0.y.z` version

- Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
- Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)

## About Mineiros

Mineiros is a [DevOps as a Service][homepage] company based in Berlin, Germany.
We offer commercial support for all of our projects and encourage you to reach out
if you have any questions or need help. Feel free to send us an email at [hello@mineiros.io] or join our [Community Slack channel][slack].

We can also help you with:

- Terraform modules for all types of infrastructure such as VPCs, Docker clusters, databases, logging and monitoring, CI, etc.
- Consulting & training on AWS, Terraform and DevOps

## Reporting Issues

We use GitHub [Issues] to track community reported issues and missing features.

## Contributing

Contributions are always encouraged and welcome! For the process of accepting changes, we use
[Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].

## Makefile Targets

This repository comes with a handy [Makefile].
Run `make help` to see details on each available target.

## License

[![license][badge-license]][apache20]

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE] for full details.

Copyright &copy; 2021 [Mineiros GmbH][homepage]

<!-- References -->

[github]: https://github.com/
[`github_repository`]: https://www.terraform.io/docs/providers/github/r/repository.html#attributes-reference
[`github_repository_collaborator`]: https://www.terraform.io/docs/providers/github/r/repository_collaborator.html#attribute-reference
[`github_repository_deploy_key`]: https://www.terraform.io/docs/providers/github/r/repository_deploy_key.html#attributes-reference
[`github_repository_project`]: https://www.terraform.io/docs/providers/github/r/repository_project.html#attributes-reference
[homepage]: https://mineiros.io/?ref=terraform-github-repository
[hello@mineiros.io]: mailto:hello@mineiros.io
[badge-build]: https://github.com/mineiros-io/terraform-github-repository/workflows/CI/CD%20Pipeline/badge.svg
[badge-semver]: https://img.shields.io/github/v/tag/mineiros-io/terraform-github-repository.svg?label=latest&sort=semver
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[badge-terraform]: https://img.shields.io/badge/terraform-1.x-623CE4.svg?logo=terraform
[badge-slack]: https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack
[badge-tf-gh]: https://img.shields.io/badge/GH-4.10+-F8991D.svg?logo=terraform
[releases-github-provider]: https://github.com/terraform-providers/terraform-provider-github/releases
[build-status]: https://github.com/mineiros-io/terraform-github-repository/actions
[releases-github]: https://github.com/mineiros-io/terraform-github-repository/releases
[releases-terraform]: https://github.com/hashicorp/terraform/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg
[terraform]: https://www.terraform.io
[aws]: https://aws.amazon.com/
[semantic versioning (semver)]: https://semver.org/
[variables.tf]: https://github.com/mineiros-io/terraform-github-repository/blob/master/variables.tf
[examples/]: https://github.com/mineiros-io/terraform-github-repository/blob/master/examples
[issues]: https://github.com/mineiros-io/terraform-github-repository/issues
[license]: https://github.com/mineiros-io/terraform-github-repository/blob/master/LICENSE
[makefile]: https://github.com/mineiros-io/terraform-github-repository/blob/master/Makefile
[pull requests]: https://github.com/mineiros-io/terraform-github-repository/pulls
[contribution guidelines]: https://github.com/mineiros-io/terraform-github-repository/blob/master/CONTRIBUTING.md
