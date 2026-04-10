[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>](https://mineiros.io/?ref=terraform-github-repository)

[![Build Status](https://github.com/mineiros-io/terraform-github-repository/workflows/CI/CD%20Pipeline/badge.svg)](https://github.com/mineiros-io/terraform-github-repository/actions)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/mineiros-io/terraform-github-repository.svg?label=latest&sort=semver)](https://github.com/mineiros-io/terraform-github-repository/releases)
[![Terraform Version](https://img.shields.io/badge/terraform-1.x-623CE4.svg?logo=terraform)](https://github.com/hashicorp/terraform/releases)
[![Github Provider Version](https://img.shields.io/badge/GH-4.10+-F8991D.svg?logo=terraform)](https://github.com/terraform-providers/terraform-provider-github/releases)
[![Join Slack](https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack)](https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg)

# terraform-github-repository

A [Terraform] module for creating a public or private repository on [Github].

**_This module supports Terraform v1.x and is compatible with the Official Terraform GitHub Provider v4.20 and above from `integrations/github`._**

**Attention: This module is incompatible with the Hashicorp GitHub Provider! The latest version of this module supporting `hashicorp/github` provider is `~> 0.10.0`**

** Note: Versions 5.3.0, 5.4.0, and 5.5.0 of the Terraform Github Provider have broken branch protections support and should not be used.**


- [GitHub as Code](#github-as-code)
- [Module Features](#module-features)
- [Getting Started](#getting-started)
- [Module Argument Reference](#module-argument-reference)
  - [Main Resource Configuration](#main-resource-configuration)
  - [Extended Resource Configuration](#extended-resource-configuration)
    - [Repository Creation Configuration](#repository-creation-configuration)
    - [Teams Configuration](#teams-configuration)
    - [Collaborator Configuration](#collaborator-configuration)
    - [Branches Configuration](#branches-configuration)
    - [Deploy Keys Configuration](#deploy-keys-configuration)
    - [Branch Protections v3 Configuration](#branch-protections-v3-configuration)
    - [Branch Protections v4 Configuration](#branch-protections-v4-configuration)
    - [Issue Labels Configuration](#issue-labels-configuration)
    - [Webhooks Configuration](#webhooks-configuration)
    - [Secrets Configuration](#secrets-configuration)
    - [Autolink References Configuration](#autolink-references-configuration)
    - [App Installations](#app-installations)
  - [Module Configuration](#module-configuration)
- [Module Outputs](#module-outputs)
- [External Documentation](#external-documentation)
  - [Terraform Github Provider Documentation](#terraform-github-provider-documentation)
- [Module Versioning](#module-versioning)
  - [Backwards compatibility in `0.0.z` and `0.y.z` version](#backwards-compatibility-in-00z-and-0yz-version)
- [About Mineiros](#about-mineiros)
- [Reporting Issues](#reporting-issues)
- [Contributing](#contributing)
- [Makefile Targets](#makefile-targets)
- [License](#license)

## GitHub as Code

[GitHub as Code][github-as-code] is a commercial solution built on top of
our open-source Terraform modules for GitHub. It helps our customers to
manage their GitHub organization more efficiently by enabling anyone in
their organization to **self-service** manage **on- and offboarding of users**,
**repositories**, and settings such as **branch protections**, **secrets**, and more
through code. GitHub as Code comes with **pre-configured GitHub Actions
pipelines** for **change pre-view in Pull Requests**, **fully automated
rollouts** and **rollbacks**. It's a comprehensive, ready-to-use blueprint
maintained by our team of platform engineering experts and saves
companies such as yours tons of time by building on top of a pre-configured
solution instead of building and maintaining it yourself.

For details please see [https://mineiros.io/github-as-code][github-as-code].

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
  Branches,
  Branch Protection,
  Issue Labels,
  Handle Github Default Issue Labels,
  Collaborators,
  Teams,
  Deploy Keys,
  Repository Webhooks

- _Features not yet implemented_:
  Actions,
  Repository File

## Getting Started

Most basic usage creating a new private github repository.

```hcl
module "repository" {
  source  = "mineiros-io/repository/github"
  version = "~> 0.18.0"

  name               = "terraform-github-repository"
  license_template   = "apache-2.0"
  gitignore_template = "Terraform"
}
```

## Module Argument Reference

See [variables.tf] and [examples/] for details and use-cases.

### Main Resource Configuration

- [**`name`**](#var-name): *(**Required** `string`)*<a name="var-name"></a>

  The name of the repository.

- [**`defaults`**](#var-defaults): *(Optional `object(defaults)`)*<a name="var-defaults"></a>

  DEPRECATED:
  This variable will be removed in future releases.
  It was needed in times when Terraform Module for each was not available to provide default values for multiple repositories.
  Please convert your code accordingly to stay compatible with future releases.

  Default is `{}`.

- [**`pages`**](#var-pages): *(Optional `object(pages)`)*<a name="var-pages"></a>

  A object of settings to configure GitHub Pages in this repository.
  See below for a list of supported arguments.

  Default is `{}`.

  The `pages` object accepts the following attributes:

  - [**`branch`**](#attr-pages-branch): *(**Required** `string`)*<a name="attr-pages-branch"></a>

    The repository branch used to publish the site's source files.

  - [**`path`**](#attr-pages-path): *(Optional `string`)*<a name="attr-pages-path"></a>

    The repository directory from which the site publishes.

  - [**`cname`**](#attr-pages-cname): *(Optional `string`)*<a name="attr-pages-cname"></a>

    The custom domain for the repository. This can only be set after the
    repository has been created.

- [**`allow_merge_commit`**](#var-allow_merge_commit): *(Optional `bool`)*<a name="var-allow_merge_commit"></a>

  Set to `false` to disable merge commits on the repository.
  If you set this to `false` you have to enable either `allow_squash_merge`
  or `allow_rebase_merge`.

  Default is `true`.

- [**`allow_squash_merge`**](#var-allow_squash_merge): *(Optional `bool`)*<a name="var-allow_squash_merge"></a>

  Set to `true` to enable squash merges on the repository.

  Default is `false`.

- [**`allow_rebase_merge`**](#var-allow_rebase_merge): *(Optional `bool`)*<a name="var-allow_rebase_merge"></a>

  Set to `true` to enable rebase merges on the repository.

  Default is `false`.

- [**`allow_auto_merge`**](#var-allow_auto_merge): *(Optional `bool`)*<a name="var-allow_auto_merge"></a>

  Set to `true`  to allow [auto-merging](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/incorporating-changes-from-a-pull-request/automatically-merging-a-pull-request)
  pull requests on the repository. If you enable auto-merge for a pull
  request, the pull request will merge automatically when all required
  reviews are met and status checks have passed.

  Default is `false`.

- [**`description`**](#var-description): *(Optional `string`)*<a name="var-description"></a>

  A description of the repository.

  Default is `""`.

- [**`delete_branch_on_merge`**](#var-delete_branch_on_merge): *(Optional `bool`)*<a name="var-delete_branch_on_merge"></a>

  Set to `false` to disable the automatic deletion of head branches after pull requests are merged.

  Default is `true`.

- [**`homepage_url`**](#var-homepage_url): *(Optional `string`)*<a name="var-homepage_url"></a>

  URL of a page describing the project.

  Default is `""`.

- [**`private`**](#var-private): *(Optional `bool`)*<a name="var-private"></a>

  **_DEPRECATED_**: Please use `visibility` instead and update your code. parameter will be removed in a future version

- [**`visibility`**](#var-visibility): *(Optional `string`)*<a name="var-visibility"></a>

  Can be `public` or `private`.
  If your organization is associated with an enterprise account using GitHub Enterprise Cloud or GitHub Enterprise Server 2.20+, `visibility` can also be `internal`.
  The `visibility` parameter overrides the deprecated `private` parameter.

  Default is `"private"`.

- [**`has_issues`**](#var-has_issues): *(Optional `bool`)*<a name="var-has_issues"></a>

  Set to true to enable the GitHub Issues features on the repository.

  Default is `false`.

- [**`has_projects`**](#var-has_projects): *(Optional `bool`)*<a name="var-has_projects"></a>

  Set to true to enable the GitHub Projects features on the repository.

  Default is `false`.

- [**`has_wiki`**](#var-has_wiki): *(Optional `bool`)*<a name="var-has_wiki"></a>

  Set to true to enable the GitHub Wiki features on the repository.

  Default is `false`.

- [**`is_template`**](#var-is_template): *(Optional `bool`)*<a name="var-is_template"></a>

  Set to `true` to tell GitHub that this is a template repository.

  Default is `false`.

- [**`default_branch`**](#var-default_branch): *(Optional `string`)*<a name="var-default_branch"></a>

  The name of the default branch of the repository.
  NOTE: The configured default branch must exist in the repository.
  If the branch doesn't exist yet, or if you are creating a new
  repository, please add the desired default branch to the `branches`
  variable, which will cause Terraform to create it for you.

  Default is `""`.

- [**`archived`**](#var-archived): *(Optional `bool`)*<a name="var-archived"></a>

  Specifies if the repository should be archived.
  NOTE: Currently, the API does not support unarchiving.

  Default is `false`.

- [**`topics`**](#var-topics): *(Optional `list(string)`)*<a name="var-topics"></a>

  The list of topics of the repository.

  Default is `[]`.

- [**`extra_topics`**](#var-extra_topics): *(Optional `list(string)`)*<a name="var-extra_topics"></a>

  A list of additional topics of the repository. Those topics will be added to the list of `topics`. This is useful if `default.topics` are used and the list should be extended with more topics.

  Default is `[]`.

- [**`vulnerability_alerts`**](#var-vulnerability_alerts): *(Optional `bool`)*<a name="var-vulnerability_alerts"></a>

  Set to `false` to disable security alerts for vulnerable dependencies.
  Enabling requires alerts to be enabled on the owner level.

- [**`archive_on_destroy`**](#var-archive_on_destroy): *(Optional `string`)*<a name="var-archive_on_destroy"></a>

  Set to `false` to not archive the repository instead of deleting on destroy.

  Default is `true`.

### Extended Resource Configuration

#### Repository Creation Configuration

The following four arguments can only be set at repository creation and
changes will be ignored for repository updates and
will not show a diff in plan or apply phase.

- [**`auto_init`**](#var-auto_init): *(Optional `bool`)*<a name="var-auto_init"></a>

  Set to `false` to not produce an initial commit in the repository.

  Default is `true`.

- [**`gitignore_template`**](#var-gitignore_template): *(Optional `string`)*<a name="var-gitignore_template"></a>

  Use the name of the template without the extension.

  Default is `""`.

- [**`license_template`**](#var-license_template): *(Optional `string`)*<a name="var-license_template"></a>

  Use the name of the template without the extension.

  Default is `""`.

- [**`template`**](#var-template): *(Optional `any`)*<a name="var-template"></a>

  Use a template repository to create this resource (object with `owner` and `repository`).

  Default is `null`.

  The object accepts the following attributes:

  - [**`owner`**](#attr-template-owner): *(**Required** `string`)*<a name="attr-template-owner"></a>

    The GitHub organization or user the template repository is owned by.

  - [**`repository`**](#attr-template-repository): *(**Required** `string`)*<a name="attr-template-repository"></a>

    The name of the template repository.

#### Teams Configuration

Your can use non-computed (known at `terraform plan`) team names or slugs (`*_teams` Attributes)
or computed (only known in `terraform apply` phase) team IDs (`*_team_ids` Attributes).
**When using non-computed names/slugs teams need to exist before running plan.**
This is due to some terraform limitation and we will update the module once terraform removed this limitation.

- [**`pull_teams`**](#var-pull_teams): *(Optional `list(string)`)*<a name="var-pull_teams"></a>

  Can also be `pull_team_ids`. A list of teams to grant pull (read-only) permission.
  Recommended for non-code contributors who want to view or discuss your project.

  Default is `[]`.

- [**`triage_teams`**](#var-triage_teams): *(Optional `list(string)`)*<a name="var-triage_teams"></a>

  Can also be `triage_team_ids`. A list of teams to grant triage permission.
  Recommended for contributors who need to proactively manage issues and pull requests
  without write access.

  Default is `[]`.

- [**`push_teams`**](#var-push_teams): *(Optional `list(string)`)*<a name="var-push_teams"></a>

  Can also be `push_team_ids`. A list of teams to grant push (read-write) permission.
  Recommended for contributors who actively push to your project.

  Default is `[]`.

- [**`maintain_teams`**](#var-maintain_teams): *(Optional `list(string)`)*<a name="var-maintain_teams"></a>

  Can also be `maintain_team_ids`. A list of teams to grant maintain permission.
  Recommended for project managers who need to manage the repository without access to sensitive or destructive actions.

  Default is `[]`.

- [**`admin_teams`**](#var-admin_teams): *(Optional `list(string)`)*<a name="var-admin_teams"></a>

  Can also be `admin_team_ids`. A list of teams to grant admin (full) permission.
  Recommended for people who need full access to the project, including sensitive and destructive actions like managing security or deleting a repository.

  Default is `[]`.

- [**`admin_team_ids`**](#var-admin_team_ids): *(Optional `list(string)`)*<a name="var-admin_team_ids"></a>

  Can also be `admin_teams`. A list of team IDs to grant admin (full) permission.

  Default is `[]`.

- [**`maintain_team_ids`**](#var-maintain_team_ids): *(Optional `list(string)`)*<a name="var-maintain_team_ids"></a>

  Can also be `maintain_teams`. A list of team IDs to grant maintain permission.

  Default is `[]`.

- [**`pull_team_ids`**](#var-pull_team_ids): *(Optional `list(string)`)*<a name="var-pull_team_ids"></a>

  Can also be `pull_teams`. A list of team IDs to grant pull (read-only) permission.

  Default is `[]`.

- [**`push_team_ids`**](#var-push_team_ids): *(Optional `list(string)`)*<a name="var-push_team_ids"></a>

  Can also be `push_teams`. A list of team IDs to grant push (read-write) permission.

  Default is `[]`.

- [**`triage_team_ids`**](#var-triage_team_ids): *(Optional `list(string)`)*<a name="var-triage_team_ids"></a>

  Can also be `triage_teams`. A list of team IDs to grant triage permission.

  Default is `[]`.

#### Collaborator Configuration

- [**`pull_collaborators`**](#var-pull_collaborators): *(Optional `list(string)`)*<a name="var-pull_collaborators"></a>

  A list of user names to add as collaborators granting them pull (read-only) permission.
  Recommended for non-code contributors who want to view or discuss your project.

  Default is `[]`.

- [**`triage_collaborators`**](#var-triage_collaborators): *(Optional `list(string)`)*<a name="var-triage_collaborators"></a>

  A list of user names to add as collaborators granting them triage permission.
  Recommended for contributors who need to proactively manage issues and pull requests without write access.

  Default is `[]`.

- [**`push_collaborators`**](#var-push_collaborators): *(Optional `list(string)`)*<a name="var-push_collaborators"></a>

  A list of user names to add as collaborators granting them push (read-write) permission.
  Recommended for contributors who actively push to your project.

  Default is `[]`.

- [**`maintain_collaborators`**](#var-maintain_collaborators): *(Optional `list(string)`)*<a name="var-maintain_collaborators"></a>

  A list of user names to add as collaborators granting them maintain permission.
  Recommended for project managers who need to manage the repository without access to sensitive or destructive actions.

  Default is `[]`.

- [**`admin_collaborators`**](#var-admin_collaborators): *(Optional `list(string)`)*<a name="var-admin_collaborators"></a>

  A list of user names to add as collaborators granting them admin (full) permission.
  Recommended for people who need full access to the project, including sensitive and destructive actions like managing security or deleting a repository.

  Default is `[]`.

#### Branches Configuration

- [**`branches`**](#var-branches): *(Optional `list(branch)`)*<a name="var-branches"></a>

  Create and manage branches within your repository.
  Additional constraints can be applied to ensure your branch is created from another branch or commit.

  Default is `[]`.

  Each `branch` object in the list accepts the following attributes:

  - [**`name`**](#attr-branches-name): *(**Required** `string`)*<a name="attr-branches-name"></a>

    The name of the branch to create.

  - [**`source_branch`**](#attr-branches-source_branch): *(Optional `string`)*<a name="attr-branches-source_branch"></a>

    The branch name to start from. Uses the configured default branch per default.

  - [**`source_sha`**](#attr-branches-source_sha): *(Optional `bool`)*<a name="attr-branches-source_sha"></a>

    The commit hash to start from. Defaults to the tip of `source_branch`. If provided, `source_branch` is ignored.

    Default is `true`.

#### Deploy Keys Configuration

- [**`deploy_keys`**](#var-deploy_keys): *(Optional `list(deploy_key)`)*<a name="var-deploy_keys"></a>

  Can also be type `list(string)`. Specifies deploy keys and access-level of deploy keys used in this repository.
  Every `string` in the list will be converted internally into the `object` representation with the `key` argument being set to the `string`. `object` details are explained below.

  Default is `[]`.

  Each `deploy_key` object in the list accepts the following attributes:

  - [**`key`**](#attr-deploy_keys-key): *(**Required** `string`)*<a name="attr-deploy_keys-key"></a>

    The SSH public key.

  - [**`title`**](#attr-deploy_keys-title): *(Optional `string`)*<a name="attr-deploy_keys-title"></a>

    A Title for the key.
    Default is the comment field of SSH public key if it is not empty else it defaults to `md5(key)`.

  - [**`read_only`**](#attr-deploy_keys-read_only): *(Optional `bool`)*<a name="attr-deploy_keys-read_only"></a>

    Specifies the level of access for the key.

    Default is `true`.

  - [**`id`**](#attr-deploy_keys-id): *(Optional `string`)*<a name="attr-deploy_keys-id"></a>

    Specifies an ID which is used to prevent resource recreation when the order in the list of deploy keys changes.
    The ID must be unique between `deploy_keys` and `deploy_keys_computed`.

    Default is `"md5(key)"`.

- [**`deploy_keys_computed`**](#var-deploy_keys_computed): *(Optional `list(deploy_key)`)*<a name="var-deploy_keys_computed"></a>

  Can also be type `string`. Same as `deploy_keys` argument with the following differences:
  Use this argument if you depend on computed keys that terraform can not use in resource `for_each` execution. Downside of this is the recreation of deploy key resources whenever the order in the list changes. **Prefer `deploy_keys` whenever possible.**
  This argument does **not** conflict with `deploy_keys` and should exclusively be used for computed resources.

  Default is `[]`.

  Each `deploy_key` object in the list accepts the following attributes:

  - [**`key`**](#attr-deploy_keys_computed-key): *(**Required** `string`)*<a name="attr-deploy_keys_computed-key"></a>

    The SSH public key.

  - [**`title`**](#attr-deploy_keys_computed-title): *(Optional `string`)*<a name="attr-deploy_keys_computed-title"></a>

    A Title for the key.
    Default is the comment field of SSH public key if it is not empty else it defaults to `md5(key)`.

  - [**`read_only`**](#attr-deploy_keys_computed-read_only): *(Optional `bool`)*<a name="attr-deploy_keys_computed-read_only"></a>

    Specifies the level of access for the key.

    Default is `true`.

  - [**`id`**](#attr-deploy_keys_computed-id): *(Optional `string`)*<a name="attr-deploy_keys_computed-id"></a>

    Specifies an ID which is used to prevent resource recreation when the order in the list of deploy keys changes.
    The ID must be unique between `deploy_keys` and `deploy_keys_computed`.

    Default is `"md5(key)"`.

#### Branch Protections v3 Configuration

- [**`branch_protections_v3`**](#var-branch_protections_v3): *(Optional `list(branch_protection_v3)`)*<a name="var-branch_protections_v3"></a>

  This resource allows you to configure v3 branch protection for repositories in your organization.
  When applied, the branch will be protected from forced pushes and deletion.
  Additional constraints, such as required status checks or restrictions on users and teams, can also be configured.

  Default is `[]`.

  Each `branch_protection_v3` object in the list accepts the following attributes:

  - [**`branch`**](#attr-branch_protections_v3-branch): *(**Required** `string`)*<a name="attr-branch_protections_v3-branch"></a>

    The Git branch to protect.

  - [**`enforce_admins`**](#attr-branch_protections_v3-enforce_admins): *(Optional `bool`)*<a name="attr-branch_protections_v3-enforce_admins"></a>

    Setting this to true enforces status checks for repository administrators.

    Default is `false`.

  - [**`require_conversation_resolution`**](#attr-branch_protections_v3-require_conversation_resolution): *(Optional `bool`)*<a name="attr-branch_protections_v3-require_conversation_resolution"></a>

    Setting this to true requires all conversations to be resolved.

    Default is `false`.

  - [**`require_signed_commits`**](#attr-branch_protections_v3-require_signed_commits): *(Optional `bool`)*<a name="attr-branch_protections_v3-require_signed_commits"></a>

    Setting this to true requires all commits to be signed with GPG.

    Default is `false`.

  - [**`required_status_checks`**](#attr-branch_protections_v3-required_status_checks): *(Optional `object(required_status_checks)`)*<a name="attr-branch_protections_v3-required_status_checks"></a>

    Enforce restrictions for required status checks.
    See Required Status Checks below for details.

    Default is `{}`.

    The `required_status_checks` object accepts the following attributes:

    - [**`strict`**](#attr-branch_protections_v3-required_status_checks-strict): *(Optional `bool`)*<a name="attr-branch_protections_v3-required_status_checks-strict"></a>

      Require branches to be up to date before merging.

      Default is `false`.

    - [**`contexts`**](#attr-branch_protections_v3-required_status_checks-contexts): *(Optional `list(string)`)*<a name="attr-branch_protections_v3-required_status_checks-contexts"></a>

      The list of status checks to require in order to merge into this branch. If default is `[]` no status checks are required.

      Default is `[]`.

  - [**`required_pull_request_reviews`**](#attr-branch_protections_v3-required_pull_request_reviews): *(Optional `object(required_pull_request_reviews)`)*<a name="attr-branch_protections_v3-required_pull_request_reviews"></a>

    Enforce restrictions for pull request reviews.

    Default is `{}`.

    The `required_pull_request_reviews` object accepts the following attributes:

    - [**`dismiss_stale_reviews`**](#attr-branch_protections_v3-required_pull_request_reviews-dismiss_stale_reviews): *(Optional `bool`)*<a name="attr-branch_protections_v3-required_pull_request_reviews-dismiss_stale_reviews"></a>

      Dismiss approved reviews automatically when a new commit is pushed.

      Default is `true`.

    - [**`dismissal_users`**](#attr-branch_protections_v3-required_pull_request_reviews-dismissal_users): *(Optional `list(string)`)*<a name="attr-branch_protections_v3-required_pull_request_reviews-dismissal_users"></a>

      The list of user logins with dismissal access

      Default is `[]`.

    - [**`dismissal_teams`**](#attr-branch_protections_v3-required_pull_request_reviews-dismissal_teams): *(Optional `list(string)`)*<a name="attr-branch_protections_v3-required_pull_request_reviews-dismissal_teams"></a>

      The list of team slugs with dismissal access.
      Always use slug of the team, not its name.
      Each team already has to have access to the repository.

      Default is `[]`.

    - [**`require_code_owner_reviews`**](#attr-branch_protections_v3-required_pull_request_reviews-require_code_owner_reviews): *(Optional `bool`)*<a name="attr-branch_protections_v3-required_pull_request_reviews-require_code_owner_reviews"></a>

      Require an approved review in pull requests including files with a designated code owner.

      Default is `false`.

  - [**`restrictions`**](#attr-branch_protections_v3-restrictions): *(Optional `object(restrictions)`)*<a name="attr-branch_protections_v3-restrictions"></a>

    Enforce restrictions for the users and teams that may push to the branch - only available for organization-owned repositories. See Restrictions below for details.

    Default is `{}`.

    The `restrictions` object accepts the following attributes:

    - [**`users`**](#attr-branch_protections_v3-restrictions-users): *(Optional `list(string)`)*<a name="attr-branch_protections_v3-restrictions-users"></a>

      The list of user logins with push access.

      Default is `[]`.

    - [**`teams`**](#attr-branch_protections_v3-restrictions-teams): *(Optional `list(string)`)*<a name="attr-branch_protections_v3-restrictions-teams"></a>

      The list of team slugs with push access.
      Always use slug of the team, not its name.
      Each team already has to have access to the repository.

      Default is `[]`.

    - [**`apps`**](#attr-branch_protections_v3-restrictions-apps): *(Optional `list(string)`)*<a name="attr-branch_protections_v3-restrictions-apps"></a>

      The list of app slugs with push access.

      Default is `[]`.

#### Branch Protections v4 Configuration

- [**`branch_protections_v4`**](#var-branch_protections_v4): *(Optional `list(branch_protection_v4)`)*<a name="var-branch_protections_v4"></a>

  This resource allows you to configure v4 branch protection for repositories in your organization.

  Each element in the list is a branch to be protected and the value the corresponding to the desired configuration for the branch.

  When applied, the branch will be protected from forced pushes and deletion.
  Additional constraints, such as required status checks or restrictions on users and teams, can also be configured.

  **_NOTE:_** May conflict with v3 branch protections if used for the same branch.

  Default is `[]`.

  Each `branch_protection_v4` object in the list accepts the following attributes:

  - [**`pattern`**](#attr-branch_protections_v4-pattern): *(**Required** `string`)*<a name="attr-branch_protections_v4-pattern"></a>

    Identifies the protection rule pattern.

  - [**`_key`**](#attr-branch_protections_v4-_key): *(Optional `string`)*<a name="attr-branch_protections_v4-_key"></a>

    An alternative key to use in `for_each` resource creation.
    Defaults to the value of `var.pattern`.

  - [**`allows_deletions`**](#attr-branch_protections_v4-allows_deletions): *(Optional `bool`)*<a name="attr-branch_protections_v4-allows_deletions"></a>

    Setting this to `true` to allow the branch to be deleted.

    Default is `false`.

  - [**`allows_force_pushes`**](#attr-branch_protections_v4-allows_force_pushes): *(Optional `bool`)*<a name="attr-branch_protections_v4-allows_force_pushes"></a>

    Setting this to `true` to allow force pushes on the branch.

    Default is `false`.

  - [**`blocks_creations`**](#attr-branch_protections_v4-blocks_creations): *(Optional `bool`)*<a name="attr-branch_protections_v4-blocks_creations"></a>

    Setting this to `true` will block creating the branch.

    Default is `false`.

  - [**`enforce_admins`**](#attr-branch_protections_v4-enforce_admins): *(Optional `bool`)*<a name="attr-branch_protections_v4-enforce_admins"></a>

    Keeping this as `true` enforces status checks for repository administrators.

    Default is `true`.

  - [**`push_restrictions`**](#attr-branch_protections_v4-push_restrictions): *(Optional `list(string)`)*<a name="attr-branch_protections_v4-push_restrictions"></a>

    The list of actor Names/IDs that may push to the branch.
    Actor names must either begin with a "/" for users or the organization name followed by a "/" for teams.

    Default is `[]`.

  - [**`require_conversation_resolution`**](#attr-branch_protections_v4-require_conversation_resolution): *(Optional `bool`)*<a name="attr-branch_protections_v4-require_conversation_resolution"></a>

    Setting this to true requires all conversations on code must be resolved before a pull request can be merged.

    Default is `false`.

  - [**`require_signed_commits`**](#attr-branch_protections_v4-require_signed_commits): *(Optional `bool`)*<a name="attr-branch_protections_v4-require_signed_commits"></a>

    Setting this to true requires all commits to be signed with GPG.

    Default is `false`.

  - [**`required_linear_history`**](#attr-branch_protections_v4-required_linear_history): *(Optional `bool`)*<a name="attr-branch_protections_v4-required_linear_history"></a>

    Setting this to true enforces a linear commit Git history, which prevents anyone from pushing merge commits to a branch.

    Default is `false`.

  - [**`required_pull_request_reviews`**](#attr-branch_protections_v4-required_pull_request_reviews): *(Optional `object(required_pull_request_reviews)`)*<a name="attr-branch_protections_v4-required_pull_request_reviews"></a>

    Enforce restrictions for pull request reviews.

    The `required_pull_request_reviews` object accepts the following attributes:

    - [**`dismiss_stale_reviews`**](#attr-branch_protections_v4-required_pull_request_reviews-dismiss_stale_reviews): *(Optional `bool`)*<a name="attr-branch_protections_v4-required_pull_request_reviews-dismiss_stale_reviews"></a>

      Dismiss approved reviews automatically when a new commit is pushed.

      Default is `true`.

    - [**`restrict_dismissals`**](#attr-branch_protections_v4-required_pull_request_reviews-restrict_dismissals): *(Optional `bool`)*<a name="attr-branch_protections_v4-required_pull_request_reviews-restrict_dismissals"></a>

      Restrict pull request review dismissals.

    - [**`dismissal_restrictions`**](#attr-branch_protections_v4-required_pull_request_reviews-dismissal_restrictions): *(Optional `list(string)`)*<a name="attr-branch_protections_v4-required_pull_request_reviews-dismissal_restrictions"></a>

      The list of actor Names/IDs with dismissal access.
      If not empty, `restrict_dismissals` is ignored
      Actor names must either begin with a `/` for users or the organization name followed by a `/` for teams.

      Default is `[]`.

    - [**`pull_request_bypassers`**](#attr-branch_protections_v4-required_pull_request_reviews-pull_request_bypassers): *(Optional `list(string)`)*<a name="attr-branch_protections_v4-required_pull_request_reviews-pull_request_bypassers"></a>

      The list of actor Names/IDs that are allowed to bypass pull request requirements.
      Actor names must either begin with a `/` for users or the organization name followed by a `/` for teams.

      Default is `[]`.

    - [**`require_code_owner_reviews`**](#attr-branch_protections_v4-required_pull_request_reviews-require_code_owner_reviews): *(Optional `bool`)*<a name="attr-branch_protections_v4-required_pull_request_reviews-require_code_owner_reviews"></a>

      Require an approved review in pull requests including files with a designated code owner.

      Default is `true`.

    - [**`required_approving_review_count`**](#attr-branch_protections_v4-required_pull_request_reviews-required_approving_review_count): *(Optional `number`)*<a name="attr-branch_protections_v4-required_pull_request_reviews-required_approving_review_count"></a>

      Require x number of approvals to satisfy branch protection requirements.
      If this is specified it must be a number between 0-6.

      Default is `0`.

  - [**`required_status_checks`**](#attr-branch_protections_v4-required_status_checks): *(Optional `object(required_status_checks)`)*<a name="attr-branch_protections_v4-required_status_checks"></a>

    Enforce restrictions for required status checks.
    See Required Status Checks below for details.

    The `required_status_checks` object accepts the following attributes:

    - [**`strict`**](#attr-branch_protections_v4-required_status_checks-strict): *(Optional `bool`)*<a name="attr-branch_protections_v4-required_status_checks-strict"></a>

      Require branches to be up to date before merging.

      Default is `false`.

    - [**`contexts`**](#attr-branch_protections_v4-required_status_checks-contexts): *(Optional `list(string)`)*<a name="attr-branch_protections_v4-required_status_checks-contexts"></a>

      The list of status checks to require in order to merge into this branch. If default is `[]` no status checks are required.

      Default is `[]`.

#### Issue Labels Configuration

- [**`issue_labels`**](#var-issue_labels): *(Optional `any`)*<a name="var-issue_labels"></a>

  This resource allows you to create and manage issue labels within your GitHub organization.
  Issue labels are keyed off of their "name", so pre-existing issue labels result in a 422 HTTP error if they exist outside of Terraform.
  Normally this would not be an issue, except new repositories are created with a "default" set of labels, and those labels easily conflict with custom ones.
  This resource will first check if the label exists, and then issue an update, otherwise it will create.

  Default is `[]`.

  The object accepts the following attributes:

  - [**`name`**](#attr-issue_labels-name): *(**Required** `string`)*<a name="attr-issue_labels-name"></a>

    The name of the label.

  - [**`color`**](#attr-issue_labels-color): *(**Required** `string`)*<a name="attr-issue_labels-color"></a>

    A 6 character hex code, without the leading `#`, identifying the color of the label.

  - [**`description`**](#attr-issue_labels-description): *(Optional `string`)*<a name="attr-issue_labels-description"></a>

    A short description of the label.

    Default is `""`.

  - [**`id`**](#attr-issue_labels-id): *(Optional `string`)*<a name="attr-issue_labels-id"></a>

    Specifies an ID which is used to prevent resource recreation when the order in the list of issue labels changes.

    Default is `"name"`.

- [**`issue_labels_merge_with_github_labels`**](#var-issue_labels_merge_with_github_labels): *(Optional `bool`)*<a name="var-issue_labels_merge_with_github_labels"></a>

  Specify if github default labels will be handled by terraform. This should be decided on upon creation of the repository. If you later decide to disable this feature, github default labels will be destroyed if not replaced by labels set in `issue_labels` argument.

- [**`issue_labels_create`**](#var-issue_labels_create): *(Optional `bool`)*<a name="var-issue_labels_create"></a>

  Specify whether you want to force or suppress the creation of issues labels.
  Default is `true` if `has_issues` is `true` or `issue_labels` is non-empty.

#### Webhooks Configuration

- [**`webhooks`**](#var-webhooks): *(Optional `list(webhook)`)*<a name="var-webhooks"></a>

  This resource allows you to create and manage webhooks for repositories in your organization.
  When applied, a webhook will be created which specifies a URL to receive events and which events to receieve. Additional constraints, such as SSL verification, pre-shared secret and content type can also be configured

  Default is `[]`.

  Each `webhook` object in the list accepts the following attributes:

  - [**`events`**](#attr-webhooks-events): *(**Required** `list(string)`)*<a name="attr-webhooks-events"></a>

    A list of events which should trigger the webhook. [See a list of available events.](https://developer.github.com/v3/activity/events/types/)

  - [**`url`**](#attr-webhooks-url): *(**Required** `string`)*<a name="attr-webhooks-url"></a>

    The URL to which the payloads will be delivered.

  - [**`active`**](#attr-webhooks-active): *(Optional `bool`)*<a name="attr-webhooks-active"></a>

    Indicate if the webhook should receive events. Defaults to `true`.

  - [**`content_type`**](#attr-webhooks-content_type): *(Optional `string`)*<a name="attr-webhooks-content_type"></a>

    The media type used to serialize the payloads. Supported values include `json` and `form`.

    Default is `"form"`.

  - [**`secret`**](#attr-webhooks-secret): *(Optional `string`)*<a name="attr-webhooks-secret"></a>

    If provided, the `secret` will be used as the `key` to generate the HMAC hex digest value in the [X-Hub-Signature](https://developer.github.com/webhooks/#delivery-headers) header.

  - [**`insecure_ssl`**](#attr-webhooks-insecure_ssl): *(Optional `bool`)*<a name="attr-webhooks-insecure_ssl"></a>

    Determines whether the SSL certificate of the host for `url` will be verified when delivering payloads. Supported values include `0` (verification is performed) and `1` (verification is not performed). The default is `0`. **We strongly recommend not setting this to `1` as you are subject to man-in-the-middle and other attacks.**

#### Secrets Configuration

- [**`plaintext_secrets`**](#var-plaintext_secrets): *(Optional `map(string)`)*<a name="var-plaintext_secrets"></a>

  This map allows you to create and manage secrets for repositories in your organization.

  Each element in the map is considered a secret to be managed, being the key map the secret name and the value the corresponding secret in plain text:

  When applied, a secret with the given key and value will be created in the repositories.

  The value of the secrets must be given in plain text, GitHub provider is in charge of encrypting it.

  **Attention:** You should treat state as sensitive always. It is also advised that you do not store plaintext values in your code but rather populate the encrypted_value using fields from a resource, data source or variable as, while encrypted in state, these will be easily accessible in your code. See below for an example of this abstraction.

  Default is `{}`.

  Example:

  ```hcl
  plaintext_secrets = {
    SECRET_NAME_1 = "plaintext_secret_value_1"
    SECRET_NAME_2 = "plaintext_secret_value_2"
  }
  ```

- [**`encrypted_secrets`**](#var-encrypted_secrets): *(Optional `map(string)`)*<a name="var-encrypted_secrets"></a>

  This map allows you to create and manage encrypted secrets for repositories in your organization.

  Each element in the map is considered a secret to be managed, being the key map the secret name and the value the corresponding encrypted value of the secret using the Github public key in Base64 format.b

  When applied, a secret with the given key and value will be created in the repositories.

  Default is `{}`.

  Example:

  ```hcl
  encrypted_secrets = {
    SECRET_NAME_1 = "c2VjcmV0X3ZhbHVlXzE="
    SECRET_NAME_2 = "c2VjcmV0X3ZhbHVlXzI="
  }
  ```

#### Autolink References Configuration

- [**`autolink_references`**](#var-autolink_references): *(Optional `any`)*<a name="var-autolink_references"></a>

  This resource allows you to create and manage autolink references for GitHub repository.

  Default is `[]`.

  The object accepts the following attributes:

  - [**`key_prefix`**](#attr-autolink_references-key_prefix): *(**Required** `string`)*<a name="attr-autolink_references-key_prefix"></a>

    This prefix appended by a number will generate a link any time it is found in an issue, pull request, or commit.

  - [**`target_url_template`**](#attr-autolink_references-target_url_template): *(**Required** `string`)*<a name="attr-autolink_references-target_url_template"></a>

    The template of the target URL used for the links; must be a valid URL and contain `<num>` for the reference number.

#### App Installations

- [**`app_installations`**](#var-app_installations): *(Optional `set(string)`)*<a name="var-app_installations"></a>

  A set of GitHub App IDs to be installed in this repository.

  Default is `{}`.

  Example:

  ```hcl
  app_installations = ["05405144", "12556423"]
  ```

### Module Configuration

- [**`module_depends_on`**](#var-module_depends_on): *(Optional `list(dependency)`)*<a name="var-module_depends_on"></a>

  Due to the fact, that terraform does not offer `depends_on` on modules as of today (v0.12.24)
  we might hit race conditions when dealing with team names instead of ids.
  So when using the feature of [adding teams by slug/name](#teams-configuration) to the repository when creating it,
  make sure to add all teams to this list as indirect dependencies.

  Default is `[]`.

## Module Outputs

The following attributes are exported by the module:

- [**`repository`**](#output-repository): *(`object(repository)`)*<a name="output-repository"></a>

  All repository attributes as returned by the [`github_repository`]
  resource containing all arguments as specified above and the other
  attributes as specified below.

- [**`branches`**](#output-branches): *(`object(branches)`)*<a name="output-branches"></a>

  All repository attributes as returned by the [`github_branch`]
  resource containing all arguments as specified above and the other
  attributes as specified below.

- [**`full_name`**](#output-full_name): *(`string`)*<a name="output-full_name"></a>

  A string of the form "orgname/reponame".

- [**`html_url`**](#output-html_url): *(`string`)*<a name="output-html_url"></a>

  URL to the repository on the web.

- [**`ssh_clone_url`**](#output-ssh_clone_url): *(`string`)*<a name="output-ssh_clone_url"></a>

  URL that can be provided to git clone to clone the repository via SSH.

- [**`http_clone_url`**](#output-http_clone_url): *(`string`)*<a name="output-http_clone_url"></a>

  URL that can be provided to git clone to clone the repository via HTTPS.

- [**`git_clone_url`**](#output-git_clone_url): *(`string`)*<a name="output-git_clone_url"></a>

  URL that can be provided to git clone to clone the repository
  anonymously via the git protocol.

- [**`collaborators`**](#output-collaborators): *(`object(collaborators)`)*<a name="output-collaborators"></a>

  A map of Collaborator objects keyed by the `name` of the collaborator as
  returned by the [`github_repository_collaborator`] resource.

- [**`deploy_keys`**](#output-deploy_keys): *(`object(deploy_keys)`)*<a name="output-deploy_keys"></a>

  A merged map of deploy key objects for the keys originally passed via
  `deploy_keys` and `deploy_keys_computed` as returned by the
  [`github_repository_deploy_key`] resource keyed by the input `id` of the
  key.

- [**`issue_labels`**](#output-issue_labels): *(`object(issue_label)`)*<a name="output-issue_labels"></a>

  A map of issue labels keyed by label input id or name.

- [**`webhooks`**](#output-webhooks): *(`object(webhook)`)*<a name="output-webhooks"></a>

  All attributes and arguments as returned by the
  `github_repository_webhook` resource.

- [**`secrets`**](#output-secrets): *(`object(secret)`)*<a name="output-secrets"></a>

  List of secrets available.

- [**`app_installations`**](#output-app_installations): *(`set(number)`)*<a name="output-app_installations"></a>

  A map of deploy app installations keyed by installation id.

## External Documentation

### Terraform Github Provider Documentation

- https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository
- https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch
- https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_collaborator
- https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_deploy_key
- https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_autolink_reference

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

[Mineiros][homepage] is a remote-first company headquartered in Berlin, Germany
that solves development, automation and security challenges in cloud infrastructure.

Our vision is to massively reduce time and overhead for teams to manage and
deploy production-grade and secure cloud infrastructure.

We offer commercial support for all of our modules and encourage you to reach out
if you have any questions or need help. Feel free to email us at [hello@mineiros.io] or join our
[Community Slack channel][slack].

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

Copyright &copy; 2020-2022 [Mineiros GmbH][homepage]


<!-- References -->

[github]: https://github.com/
[`github_repository`]: https://www.terraform.io/docs/providers/github/r/repository.html#attributes-reference
[`github_repository_collaborator`]: https://www.terraform.io/docs/providers/github/r/repository_collaborator.html#attribute-reference
[`github_repository_deploy_key`]: https://www.terraform.io/docs/providers/github/r/repository_deploy_key.html#attributes-reference
[`github_repository_autolink_reference`]: https://www.terraform.io/docs/providers/github/r/repository_autolink_reference.html#attributes-reference
[homepage]: https://mineiros.io/?ref=terraform-github-repository
[github-as-code]: https://mineiros.io/github-as-code?ref=terraform-github-repository
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
[variables.tf]: https://github.com/mineiros-io/terraform-github-repository/blob/main/variables.tf
[examples/]: https://github.com/mineiros-io/terraform-github-repository/blob/main/examples
[issues]: https://github.com/mineiros-io/terraform-github-repository/issues
[license]: https://github.com/mineiros-io/terraform-github-repository/blob/main/LICENSE
[makefile]: https://github.com/mineiros-io/terraform-github-repository/blob/main/Makefile
[pull requests]: https://github.com/mineiros-io/terraform-github-repository/pulls
[contribution guidelines]: https://github.com/mineiros-io/terraform-github-repository/blob/main/CONTRIBUTING.md

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_github"></a> [github](#requirement\_github) | ~> 6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | 6.11.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [github_actions_secret.repository_secret](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret) | resource |
| [github_app_installation_repository.app_installation_repository](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/app_installation_repository) | resource |
| [github_branch.branch](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch) | resource |
| [github_branch_default.default](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_default) | resource |
| [github_branch_protection.branch_protection](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_protection) | resource |
| [github_branch_protection_v3.branch_protection](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_protection_v3) | resource |
| [github_issue_label.label](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/issue_label) | resource |
| [github_repository.repository](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository) | resource |
| [github_repository_autolink_reference.repository_autolink_reference](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_autolink_reference) | resource |
| [github_repository_collaborator.collaborator](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_collaborator) | resource |
| [github_repository_deploy_key.deploy_key](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_deploy_key) | resource |
| [github_repository_deploy_key.deploy_key_computed](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_deploy_key) | resource |
| [github_repository_webhook.repository_webhook](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_webhook) | resource |
| [github_team_repository.team_repository](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/team_repository) | resource |
| [github_team_repository.team_repository_by_slug](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/team_repository) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_collaborators"></a> [admin\_collaborators](#input\_admin\_collaborators) | (Optional) A list of users to add as collaborators granting them admin (full) permission. | `list(string)` | `[]` | no |
| <a name="input_admin_team_ids"></a> [admin\_team\_ids](#input\_admin\_team\_ids) | (Optional) A list of teams (by id) to grant admin (full) permission to. | `list(string)` | `[]` | no |
| <a name="input_admin_teams"></a> [admin\_teams](#input\_admin\_teams) | (Optional) A list of teams (by name/slug) to grant admin (full) permission to. | `list(string)` | `[]` | no |
| <a name="input_allow_auto_merge"></a> [allow\_auto\_merge](#input\_allow\_auto\_merge) | (Optional) Set to true to allow auto-merging pull requests on the repository. If enabled for a pull request, the pull request will merge automatically when all required reviews are met and status checks have passed. (Default: false) | `bool` | `null` | no |
| <a name="input_allow_merge_commit"></a> [allow\_merge\_commit](#input\_allow\_merge\_commit) | (Optional) Set to false to disable merge commits on the repository. (Default: true) | `bool` | `null` | no |
| <a name="input_allow_rebase_merge"></a> [allow\_rebase\_merge](#input\_allow\_rebase\_merge) | (Optional) Set to true to enable rebase merges on the repository. (Default: false) | `bool` | `null` | no |
| <a name="input_allow_squash_merge"></a> [allow\_squash\_merge](#input\_allow\_squash\_merge) | (Optional) Set to true to enable squash merges on the repository. (Default: false) | `bool` | `null` | no |
| <a name="input_app_installations"></a> [app\_installations](#input\_app\_installations) | (Optional) A list of GitHub App IDs to be installed in this repository. | `set(string)` | `[]` | no |
| <a name="input_archive_on_destroy"></a> [archive\_on\_destroy](#input\_archive\_on\_destroy) | (Optional) Set to `false` to not archive the repository instead of deleting on destroy. | `string` | `true` | no |
| <a name="input_archived"></a> [archived](#input\_archived) | (Optional) Specifies if the repository should be archived. (Default: false) | `bool` | `false` | no |
| <a name="input_auto_init"></a> [auto\_init](#input\_auto\_init) | (Optional) Wether or not to produce an initial commit in the repository. (Default: true) | `bool` | `null` | no |
| <a name="input_autolink_references"></a> [autolink\_references](#input\_autolink\_references) | (Optional) Configuring autolink references. For details please check: https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_autolink_reference | `any` | `[]` | no |
| <a name="input_branch_protections_v3"></a> [branch\_protections\_v3](#input\_branch\_protections\_v3) | (Optional) A list of branch protections to apply to the repository. Default is [] unless branch\_protections is set. | `any` | `[]` | no |
| <a name="input_branch_protections_v4"></a> [branch\_protections\_v4](#input\_branch\_protections\_v4) | (Optional) A list of v4 branch protections to apply to the repository. Default is []. | `any` | `[]` | no |
| <a name="input_branches"></a> [branches](#input\_branches) | (Optional) A list of branches to be created in this repository. | `any` | `[]` | no |
| <a name="input_default_branch"></a> [default\_branch](#input\_default\_branch) | (Optional) The name of the default branch of the repository. NOTE: This can only be set after a repository has already been created, and after a correct reference has been created for the target branch inside the repository. This means a user will have to omit this parameter from the initial repository creation and create the target branch inside of the repository prior to setting this attribute. | `string` | `null` | no |
| <a name="input_defaults"></a> [defaults](#input\_defaults) | (Deprecated) DEPRECATED. Please convert defaults to Terraform Module for\_each | `any` | `{}` | no |
| <a name="input_delete_branch_on_merge"></a> [delete\_branch\_on\_merge](#input\_delete\_branch\_on\_merge) | (Optional) Whether or not to delete the merged branch after merging a pull request. (Default: false) | `bool` | `null` | no |
| <a name="input_deploy_keys"></a> [deploy\_keys](#input\_deploy\_keys) | (Optional) Configure a deploy key ( SSH key ) that grants access to a single GitHub repository. This key is attached directly to the repository instead of to a personal user account. | `any` | `[]` | no |
| <a name="input_deploy_keys_computed"></a> [deploy\_keys\_computed](#input\_deploy\_keys\_computed) | (Optional) Configure a deploy key ( SSH key ) that grants access to a single GitHub repository. This key is attached directly to the repository instead of to a personal user account. | `any` | `[]` | no |
| <a name="input_description"></a> [description](#input\_description) | (Optional) A description of the repository. | `string` | `""` | no |
| <a name="input_encrypted_secrets"></a> [encrypted\_secrets](#input\_encrypted\_secrets) | (Optional) Configuring encrypted actions secrets. For details please check: https://www.terraform.io/docs/providers/github/r/actions_secret | `map(string)` | `{}` | no |
| <a name="input_extra_topics"></a> [extra\_topics](#input\_extra\_topics) | (Optional) The list of additional topics of the repository. (Default: []) | `list(string)` | `[]` | no |
| <a name="input_gitignore_template"></a> [gitignore\_template](#input\_gitignore\_template) | (Optional) Use the name of the template without the extension. For example, Haskell. Available templates: https://github.com/github/gitignore | `string` | `null` | no |
| <a name="input_has_issues"></a> [has\_issues](#input\_has\_issues) | (Optional) Set to true to enable the GitHub Issues features on the repository. (Default: false) | `bool` | `null` | no |
| <a name="input_has_projects"></a> [has\_projects](#input\_has\_projects) | (Optional) Set to true to enable the GitHub Projects features on the repository. Per the github documentation when in an organization that has disabled repository projects it will default to false and will otherwise default to true. If you specify true when it has been disabled it will return an error.  (Default: false) | `bool` | `null` | no |
| <a name="input_has_wiki"></a> [has\_wiki](#input\_has\_wiki) | (Optional) Set to true to enable the GitHub Wiki features on the repository. (Default: false) | `bool` | `null` | no |
| <a name="input_homepage_url"></a> [homepage\_url](#input\_homepage\_url) | (Optional) The website of the repository. | `string` | `null` | no |
| <a name="input_is_template"></a> [is\_template](#input\_is\_template) | (Optional) Whether or not to tell GitHub that this is a template repository. ( Default: false) | `bool` | `null` | no |
| <a name="input_issue_labels"></a> [issue\_labels](#input\_issue\_labels) | (Optional) Configure a GitHub issue label resource. Each element is an object with `name`, `description`, and `color` (strings). | `any` | `[]` | no |
| <a name="input_issue_labels_create"></a> [issue\_labels\_create](#input\_issue\_labels\_create) | (Optional) Specify whether you want to force or suppress the creation of issues labels. | `bool` | `null` | no |
| <a name="input_issue_labels_merge_with_github_labels"></a> [issue\_labels\_merge\_with\_github\_labels](#input\_issue\_labels\_merge\_with\_github\_labels) | (Optional) Specify if you want to merge and control githubs default set of issue labels. | `bool` | `null` | no |
| <a name="input_license_template"></a> [license\_template](#input\_license\_template) | (Optional) Use the name of the template without the extension. For example, 'mit' or 'mpl-2.0'. Available licences: https://github.com/github/choosealicense.com/tree/gh-pages/_licenses | `string` | `null` | no |
| <a name="input_maintain_collaborators"></a> [maintain\_collaborators](#input\_maintain\_collaborators) | (Optional) A list of users to add as collaborators granting them maintain permission. | `list(string)` | `[]` | no |
| <a name="input_maintain_team_ids"></a> [maintain\_team\_ids](#input\_maintain\_team\_ids) | (Optional) A list of teams (by id) to grant maintain permission to. | `list(string)` | `[]` | no |
| <a name="input_maintain_teams"></a> [maintain\_teams](#input\_maintain\_teams) | (Optional) A list of teams (by name/slug) to grant maintain permission to. | `list(string)` | `[]` | no |
| <a name="input_module_depends_on"></a> [module\_depends\_on](#input\_module\_depends\_on) | (Optional) Define resources this module indirectly depends\_on. | `any` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the repository. | `string` | n/a | yes |
| <a name="input_pages"></a> [pages](#input\_pages) | (Optional) The repository's GitHub Pages configuration. (Default: {}) | `any` | `null` | no |
| <a name="input_plaintext_secrets"></a> [plaintext\_secrets](#input\_plaintext\_secrets) | (Optional) Configuring actions secrets. For details please check: https://www.terraform.io/docs/providers/github/r/actions_secret | `map(string)` | `{}` | no |
| <a name="input_private"></a> [private](#input\_private) | (Optional) (DEPRECATED: use visibility) | `bool` | `null` | no |
| <a name="input_pull_collaborators"></a> [pull\_collaborators](#input\_pull\_collaborators) | (Optional) A list of users to add as collaborators granting them pull (read-only) permission. | `list(string)` | `[]` | no |
| <a name="input_pull_team_ids"></a> [pull\_team\_ids](#input\_pull\_team\_ids) | (Optional) A list of teams (by id) to grant pull (read-only) permission to. | `list(string)` | `[]` | no |
| <a name="input_pull_teams"></a> [pull\_teams](#input\_pull\_teams) | (Optional) A list of teams (by name/slug) to grant pull (read-only) permission to. | `list(string)` | `[]` | no |
| <a name="input_push_collaborators"></a> [push\_collaborators](#input\_push\_collaborators) | (Optional) A list of users to add as collaborators granting them push (read-write) permission. | `list(string)` | `[]` | no |
| <a name="input_push_team_ids"></a> [push\_team\_ids](#input\_push\_team\_ids) | (Optional) A list of teams (by id) to grant push (read-write) permission to. | `list(string)` | `[]` | no |
| <a name="input_push_teams"></a> [push\_teams](#input\_push\_teams) | (Optional) A list of teams (by name/slug) to grant push (read-write) permission to. | `list(string)` | `[]` | no |
| <a name="input_template"></a> [template](#input\_template) | (Optional) Template repository to use: an object with `owner` and `repository`. (Default: null) | `any` | `null` | no |
| <a name="input_topics"></a> [topics](#input\_topics) | (Optional) The list of topics of the repository.  (Default: []) | `list(string)` | `null` | no |
| <a name="input_triage_collaborators"></a> [triage\_collaborators](#input\_triage\_collaborators) | (Optional) A list of users to add as collaborators granting them triage permission. | `list(string)` | `[]` | no |
| <a name="input_triage_team_ids"></a> [triage\_team\_ids](#input\_triage\_team\_ids) | (Optional) A list of teams (by id) to grant triage permission to. | `list(string)` | `[]` | no |
| <a name="input_triage_teams"></a> [triage\_teams](#input\_triage\_teams) | (Optional) A list of teams (by name/slug) to grant triage permission to. | `list(string)` | `[]` | no |
| <a name="input_visibility"></a> [visibility](#input\_visibility) | (Optional) Can be 'public', 'private' or 'internal' (GHE only).The visibility parameter overrides the private parameter. Defaults to 'private' if neither private nor visibility are set, default to state of private parameter if it is set. | `string` | `null` | no |
| <a name="input_vulnerability_alerts"></a> [vulnerability\_alerts](#input\_vulnerability\_alerts) | (Optional) Set to `false` to disable security alerts for vulnerable dependencies. Enabling requires alerts to be enabled on the owner level. | `bool` | `null` | no |
| <a name="input_webhooks"></a> [webhooks](#input\_webhooks) | (Optional) Configuring webhooks. For details please check: https://www.terraform.io/docs/providers/github/r/repository_webhook.html | `any` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_installations"></a> [app\_installations](#output\_app\_installations) | A map of deploy app installations keyed by installation id. |
| <a name="output_branches"></a> [branches](#output\_branches) | A map of branch objects keyed by branch name. |
| <a name="output_collaborators"></a> [collaborators](#output\_collaborators) | A map of collaborator objects keyed by collaborator.name. |
| <a name="output_deploy_keys"></a> [deploy\_keys](#output\_deploy\_keys) | A map of deploy keys keyed by input id. |
| <a name="output_full_name"></a> [full\_name](#output\_full\_name) | A string of the form 'orgname/reponame'. |
| <a name="output_git_clone_url"></a> [git\_clone\_url](#output\_git\_clone\_url) | URL that can be provided to git clone to clone the repository anonymously via the git protocol. |
| <a name="output_html_url"></a> [html\_url](#output\_html\_url) | URL to the repository on the web. |
| <a name="output_http_clone_url"></a> [http\_clone\_url](#output\_http\_clone\_url) | URL that can be provided to git clone to clone the repository via HTTPS. |
| <a name="output_issue_labels"></a> [issue\_labels](#output\_issue\_labels) | A map of issue labels keyed by label input id or name. |
| <a name="output_repository"></a> [repository](#output\_repository) | All attributes and arguments as returned by the github\_repository resource. |
| <a name="output_secrets"></a> [secrets](#output\_secrets) | List of secrets available. |
| <a name="output_ssh_clone_url"></a> [ssh\_clone\_url](#output\_ssh\_clone\_url) | URL that can be provided to git clone to clone the repository via SSH. |
| <a name="output_webhooks"></a> [webhooks](#output\_webhooks) | All attributes and arguments as returned by the github\_repository\_webhook resource. |
<!-- END_TF_DOCS -->