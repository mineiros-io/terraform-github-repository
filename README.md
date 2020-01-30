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
  Gitignore Template

- **Extended S3 Features**:
  Branch Protection,
  Issue Labels,
  Collaborators,
  Teams,
  Deploy Keys,
  Projects

- *Features not yet implemented*:
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

##### Deploy Key Configuration

- **[`deploy_keys`](#deploy_keys-object-attributes)**: *(Optional `list(object|string)`)*
Specifies deploy keys and access-level of deploy keys used in this repository.
Every `string` in the list will be converted internally into the `object`
representation with the `key` argument being set to the `string`.
`object` details are explained below.
Default is `[]`.

- **[`deploy_keys_computed`](#deploy_keys-object-attributes)**: *(Optional `list(object|string)`)*
Use this argument if you depend on computed keys that terraform can not use in
resource `for_each` execution. Downside of this is the recreation of deploy key
resources whenever the order in the list changes. Prefer `deploy_keys` whenever possible.
This argument does **not** conflict with `deploy_keys` and can be used only for computed resources.
Default is `[]`.

#### [`template`](#repository-configuration) Object Attributes
- **`owner`**: ***(Required `string`)***
The GitHub organization or user the template repository is owned by.

- **`repository`**: ***(Required `string`)***
The name of the template repository.

#### [`deploy_keys`](#deploy-key-configuration) Object Attributes
- **`key`**: ***(Required `string`)***
The SSH public key.

- **`title`**: *(Optional `string`)*
A Title for the key.
Default is the comment field of SSH public key if it is not empty else it defaults to
`md5(key)`.

- **`read_only`**: *(Optional `bool`)*
Specifies teh level of access for the key.
Default is `true`.

- *`id`*: *(Optional `string`)*
Specifies an ID which is used to prevent resource recreation when the order in
the list of deploy keys changes.
The ID must be unique between `deploy_keys` and `deploy_keys_computed`.
Default is `md5(key)`.

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

#### Backwards compatibility in `0.0.z` and `0.y.z` version
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
