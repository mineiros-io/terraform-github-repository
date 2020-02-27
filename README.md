<img src="https://i.imgur.com/t8IkKoZl.png" width="200"/>

[![Maintained by Mineiros.io](https://img.shields.io/badge/maintained%20by-mineiros.io-00607c.svg)](https://www.mineiros.io/ref=repo_terraform-github-repository)
[![Build Status](https://mineiros.semaphoreci.com/badges/terraform-github-repository/branches/master.svg?style=shields)](https://mineiros.semaphoreci.com/badges/terraform-github-repository/branches/master.svg?style=shields)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/mineiros-io/terraform-github-repository.svg?label=latest&sort=semver)](https://github.com/mineiros-io/terraform-github-repository/releases)
[![Terraform Version](https://img.shields.io/badge/terraform-~%3E%200.12.20-brightgreen.svg)](https://github.com/hashicorp/terraform/releases)
[![Github Provider Version](https://img.shields.io/badge/github--provider-%3E%3D%202.3.1-brightgreen.svg)](https://github.com/terraform-providers/terraform-provider-github/releases)
[![License](https://img.shields.io/badge/License-Apache%202.0-brightgreen.svg)](https://opensource.org/licenses/Apache-2.0)

# terraform-github-repository

A [Terraform](https://www.terraform.io) 0.12 base module for
creating a public or private repository on
[Github](https://github.com/).

- [Module Features](#module-features)
- [Getting Started](#getting-started)
- [Module Argument Reference](#module-argument-reference)
- [Module Attributes Reference](#module-attributes-reference)
- [Module Versioning](#module-versioning)
- [About Mineiros](#about-mineiros)
- [Reporting Issues](#reporting-issues)
- [Contributing](#contributing)
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
  Projects

- *Features not yet implemented*:
  Repository Webhooks,
  Project Columns support

## Getting Started
Most basic usage creating a new private github repository.

```hcl
module "repository" {
  source  = "mineiros-io/repository/github"
  version = "0.0.8"

  name               = "terraform-github-repository"
  license_template   = "apache-2.0"
  gitignore_template = "Terraform"
}
```

## Module Argument Reference
See
[variables.tf](https://github.com/mineiros-io/terraform-github-repository/blob/master/variables.tf)
and
[examples/](https://github.com/mineiros-io/terraform-github-repository/blob/master/examples)
for details and use-cases.

#### Top-level Arguments

##### Repository Configuration
- **`name`**: ***(Required `string`)***
The name of the repository.

- **[`defaults`](#defaults-object-attributes)**: *(Optional `object`)*
A object of default settings to use instead of module defaults for top-level arguments.
See below for a list of supported arguments.
Default is `{}` - use module defaults as described in the README.

- **`allow_merge_commit`**: *(Optional `bool`)*
Set to `false` to disable merge commits on the repository.
If you set this to `false` you have to enable either `allow_squash_merge`
or `allow_rebase_merge`.
Default is `true`.

- **`allow_squash_merge`**: *(Optional `bool`)*
Set to `true` to enable squash merges on the repository.
Default is `false`.

- **`allow_rebase_merge`**: *(Optional `bool`)*
Set to `true` to enable rebase merges on the repository.
Default is `false`.

- **`description`**: *(Optional `string`)*
A description of the repository.
Default is `""`

- **`homepage_url`**: *(Optional `string`)*
URL of a page describing the project.
Default is `""`

- **`private`**: *(Optional `bool`)*
Set to false to create a public repository.
Default is `true`

- **`has_issues`**: *(Optional `bool`)*
Set to true to enable the GitHub Issues features on the repository.
Default is `false`

- **`has_projects`**: *(Optional `bool`)*
Set to true to enable the GitHub Projects features on the repository.
Default is `false`

- **`has_wiki`**: *(Optional `bool`)*
Set to true to enable the GitHub Wiki features on the repository.
Default is `false`

- **`has_downloads`**: *(Optional `bool`)*
Set to `true` to enable the (deprecated) downloads features on the repository.
Default is `false`.

- **`default_branch`**: *(Optional `string`)*
The name of the default branch of the repository.
NOTE: This can only be set after a repository has already been created, and
after a correct reference has been created for the target branch inside the repository.
This means a user will have to omit this parameter from the initial repository creation and
create the target branch inside of the repository prior to setting this attribute.
Default is `""`

- **`archived`**: *(Optional `bool`)*
Specifies if the repository should be archived.
NOTE: Currently, the API does not support unarchiving.
Default is `false`.

- **`topics`**: *(Optional `list(string)`)*
The list of topics of the repository.
Default is `[]`.

- **`extra_topics`**: *(Optional `list(string)`)*
A list of additional topics of the repository. Those topics will be added to
the list of `topics`. This is useful if `default.topics` are used and the list
should be extended with more topics.
Default is `[]`.

##### Repository Creation Configuration
The following four arguments can only be set at repository creation and
changes will be ignored for repository updates and
will not show a diff in plan or apply phase.

- **`auto_init`**: *(Optional `bool`)*
Set to `false` to not produce an initial commit in the repository.
Default is `true`.

- **`gitignore_template`**: *(Optional `string`)*
Use the name of the template without the extension.
Default is `""`

- **`license_template`**: *(Optional `string`)*
Use the name of the template without the extension.
Default is `""`

- **[`template`](#template-object-attributes)**: *(Optional `object`)*
Use a template repository to create this resource.
See [Template Object Attributes](#template-object-attributes) below for details.

##### Collaborator Configuration
- **`pull_collaborators`**: *(Optional `list(string)`)*
A list of user names to add as collaborators granting them pull (read-only) permission.
Recommended for non-code contributors who want to view or discuss your project.
Default is `[]`.

- **`triage_collaborators`**: *(Optional `list(string)`)*
A list of user names to add as collaborators granting them triage permission.
Recommended for contributors who need to proactively manage issues and pull requests
without write access.
Default is `[]`.

- **`push_collaborators`**: *(Optional `list(string)`)*
A list of user names to add as collaborators granting them push (read-write) permission.
Recommended for contributors who actively push to your project.
Default is `[]`.

- **`maintain_collaborators`**: *(Optional `list(string)`)*
A list of user names to add as collaborators granting them maintain permission.
Recommended for project managers who need to manage the repository without access
to sensitive or destructive actions.
Default is `[]`.

- **`admin_collaborators`**: *(Optional `list(string)`)*
A list of user names to add as collaborators granting them admin (full) permission.
Recommended for people who need full access to the project, including sensitive
and destructive actions like managing security or deleting a repository.
Default is `[]`.

##### Deploy Keys Configuration
- **[`deploy_keys`](#deploy_key-object-attributes)**: *(Optional `list(deploy_key|string)`)*
Specifies deploy keys and access-level of deploy keys used in this repository.
Every `string` in the list will be converted internally into the `object`
representation with the `key` argument being set to the `string`.
`object` details are explained below.
Default is `[]`.

- **[`deploy_keys_computed`](#deploy_key-object-attributes)**: *(Optional `list(deploy_key|string)`)*
Same as `deploy_keys` argument with the following differences:
Use this argument if you depend on computed keys that terraform can not use in
resource `for_each` execution. Downside of this is the recreation of deploy key
resources whenever the order in the list changes. **Prefer `deploy_keys` whenever possible.**
This argument does **not** conflict with `deploy_keys` and should exclusively be
used for computed resources.
Default is `[]`.

##### Branch Protections Configuration
- **[`branch_protections`](#branch_protection-object-attributes)**: *(Optional `list(branch_protection)`)*
This resource allows you to configure branch protection for repositories in your organization.
When applied, the branch will be protected from forced pushes and deletion.
Additional constraints, such as required status checks or restrictions on users and teams,
can also be configured.
Default is `[]`.

##### Issue Labels Configuration
- **[`issue_labels`](#issue_label-object-attributes)**: *(Optional `list(issue_label)`)*
This resource allows you to create and manage issue labels within your GitHub organization.
Issue labels are keyed off of their "name", so pre-existing issue labels result
in a 422 HTTP error if they exist outside of Terraform.
Normally this would not be an issue, except new repositories are created with a
"default" set of labels, and those labels easily conflict with custom ones.
This resource will first check if the label exists, and then issue an update,
otherwise it will create.
Default is `[]`.

- **[`issue_labels_merge_with_github_labels`](#issue_label-object-attributes)**: *(Optional `bool`)*
Specify if github default labels will be handled by terraform. This should be decided on upon creation of the repository. If you later decide to disable this feature, github default labels will be destroyed if not
replaced by labels set in `issue_labels` argument.
Default is `true`.

##### Projects Configuration
- **[`projects`](#project-object-attributes)**: *(Optional `list(project)`)*
This resource allows you to create and manage projects for GitHub repository.
Default is `[]`.

#### [`defaults`](#repository-configuration) Object Attributes
This is a special argument to set various defaults to be reused for multiple repositories.
The following top-level arguments can be set as defaults:
`homepage_url`,
`private`,
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
`issue_labels_merge_with_github_labels`.
Module defaults are used for all arguments that are not set in `defaults`.
Using top level arguments override defaults set by this argument.
Default is `{}`.

#### [`template`](#repository-creation-configuration) Object Attributes
- **`owner`**: ***(Required `string`)***
The GitHub organization or user the template repository is owned by.

- **`repository`**: ***(Required `string`)***
The name of the template repository.

#### [`deploy_key`](#deploy-keys-configuration) Object Attributes
- **`key`**: ***(Required `string`)***
The SSH public key.

- **`title`**: *(Optional `string`)*
A Title for the key.
Default is the comment field of SSH public key if it is not empty else it defaults to
`md5(key)`.

- **`read_only`**: *(Optional `bool`)*
Specifies the level of access for the key.
Default is `true`.

- *`id`*: *(Optional `string`)*
Specifies an ID which is used to prevent resource recreation when the order in
the list of deploy keys changes.
The ID must be unique between `deploy_keys` and `deploy_keys_computed`.
Default is `md5(key)`.

#### [`branch_protection`](#branch-protections-configuration) Object Attributes
- **`branch`**: ***(Required `string`)***
The Git branch to protect.

- **`enforce_admins`**: *(Optional `bool`)*
Setting this to true enforces status checks for repository administrators.
Default is `false`.

- **`require_signed_commits`**: *(Optional `bool`)*
Setting this to true requires all commits to be signed with GPG.
Default is `false`.

- **`required_status_checks`**: *(Optional `required_status_checks`)*
Enforce restrictions for required status checks.
See Required Status Checks below for details.
Default is `{}`.

- **`required_pull_request_reviews`**: *(Optional `required_pull_request_reviews`)*
Enforce restrictions for pull request reviews.
See Required Pull Request Reviews below for details.
Default is `{}`.

- **`restrictions`**: *(Optional `restrictions`)*
Enforce restrictions for the users and teams that may push to the branch -
only available for organization-owned repositories. See Restrictions below for details.
Default is `{}`.

##### [`required_status_checks`](#branch_protection-object-attributes) Object Attributes
- **`strict`**: *(Optional `bool`)*
Require branches to be up to date before merging.
Defaults is `false`.

- **`contexts`**: *(Optional `list(string)`)*
The list of status checks to require in order to merge into this branch.
Default is `[]` - No status checks are required.

##### [`required_pull_request_reviews`](#branch_protection-object-attributes) Object Attributes
- **`dismiss_stale_reviews`**: *(Optional `bool`)*
Dismiss approved reviews automatically when a new commit is pushed.
Default is `false`.

- **`dismissal_users`**: *(Optional `list(string)`)*
The list of user logins with dismissal access
Default is `[]`.

- **`dismissal_teams`**: *(Optional `list(string)`)*
The list of team slugs with dismissal access.
Always use slug of the team, not its name.
Each team already has to have access to the repository.
Default is `[]`.

- **`require_code_owner_reviews`**: *(Optional `bool`)*
Require an approved review in pull requests including files with a designated code owner.
Defaults is `false`.

- **`required_approving_review_count`**: *(Optional `number`)*
Require x number of approvals to satisfy branch protection requirements.
If this is specified it must be a number between 1-6.
This requirement matches Github's API, see the upstream documentation for more information.
Default is no approving reviews are required.

##### [`restrictions`](#branch_protection-object-attributes) Object Attributes
- **`users`**: *(Optional `list(string)`)*
The list of user logins with push access.
Default is `[]`.

- **`teams`**: *(Optional `list(string)`)*
The list of team slugs with push access.
Always use slug of the team, not its name.
Each team already has to have access to the repository.
Default is `[]`.

#### [`issue_label`](#issue-labels-configuration) Object Attributes
- **`name`**: ***(Required `string`)***
The name of the label.

- **`color`**: ***(Required `string`)***
A 6 character hex code, without the leading #, identifying the color of the label.

- **`description`**: *(Optional `string`)*
A short description of the label.
Default is `""`.

- *`id`*: *(Optional `string`)*
Specifies an ID which is used to prevent resource recreation when the order in
the list of issue labels changes.
Default is `name`.

#### [`project`](#projects-configuration) Object Attributes
- **`name`**: ***(Required `string`)***
The name of the project.

- **`body`**: *(Optional `string`)*
The body of the project.
Default is `""`.

- *`id`*: *(Optional `string`)*
Specifies an ID which is used to prevent resource recreation when the order in
the list of projects changes.
Default is `name`.

## Module Attributes Reference
The following attributes are exported by the module:

- **`repository`**: All repository attributes as returned by the
[`github_repository` resource](https://www.terraform.io/docs/providers/github/r/repository.html#attributes-reference)
containing all arguments as specified above and the other attributes as specified below.
- **`full_name`**: A string of the form "orgname/reponame".
- **`html_url`**: URL to the repository on the web.
- **`ssh_clone_url`**: URL that can be provided to git clone to clone the repository via SSH.
- **`http_clone_url`**: URL that can be provided to git clone to clone the repository via HTTPS.
- **`git_clone_url`**: URL that can be provided to git clone to clone the repository anonymously via the git protocol.

- **`collaborators`**: A map of Collaborator objects keyed by the `name` of the collaborator as returned by the
[`github_repository_collaborator` resource](https://www.terraform.io/docs/providers/github/r/repository_collaborator.html#attribute-reference).

- **`deploy_keys`**: A merged map of deploy key objects for the keys originally passed via `deploy_keys` and `deploy_keys_computed` as returned by the
[`github_repository_deploy_key` resource](https://www.terraform.io/docs/providers/github/r/repository_deploy_key.html#attributes-reference)
keyed by the input `id` of the key.

- **`projects`**: A map of Project objects keyed by the `id` of the project as returned by the
[`github_repository_project` resource](https://www.terraform.io/docs/providers/github/r/repository_project.html#attributes-reference).

## Module Versioning
This Module follows the principles of [Semantic Versioning (SemVer)](https://semver.org/).

Given a version number `MAJOR.MINOR.PATCH`, we increment the:
1) `MAJOR` version when we make incompatible changes,
2) `MINOR` version when we add functionality in a backwards compatible manner, and
3) `PATCH` version when we make backwards compatible bug fixes.

### Backwards compatibility in `0.0.z` and `0.y.z` version
- Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
- Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)

## About Mineiros
Mineiros is a [DevOps as a Service](https://mineiros.io/) Company based in Berlin, Germany.
We offer Commercial Support for all of our projects, just send us an email to [hello@mineiros.io](mailto:hello@mineiros.io).

We can also help you with:
- Terraform Modules for all types of infrastructure such as VPC's, Docker clusters,
databases, logging and monitoring, CI, etc.
- Complex Cloud- and Multi Cloud environments.
- Consulting & Training on AWS, Terraform and DevOps.

## Reporting Issues
We use GitHub [Issues](https://github.com/mineiros-io/terraform-github-repository/issues) to track community reported issues and missing features.

## Contributing
Contributions are very welcome!
We use [Pull Requests](https://github.com/mineiros-io/terraform-github-repository/pulls)
for accepting changes.
Please see our
[Contribution Guidelines](https://github.com/mineiros-io/terraform-github-repository/blob/master/CONTRIBUTING.md)
for full details.

### Makefile Targets
This repository comes with a handy [https://github.com/mineiros-io/terraform-module-template/blob/master/Makefile](Makefile).
Run `make help` to see details on each available target.

## License
This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE](https://github.com/mineiros-io/terraform-github-repository/blob/master/LICENSE) for full details.

Copyright &copy; 2020 Mineiros
