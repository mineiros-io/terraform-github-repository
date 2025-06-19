<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.7 |
| <a name="requirement_github"></a> [github](#requirement\_github) | ~> 6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | 6.6.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [github_actions_secret.plaintext_repository_secret](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret) | resource |
| [github_actions_secret.repository_secret](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret) | resource |
| [github_actions_variable.repository_variable](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_variable) | resource |
| [github_app_installation_repository.app_installation_repository](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/app_installation_repository) | resource |
| [github_branch.branch](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch) | resource |
| [github_branch_default.default](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_default) | resource |
| [github_branch_protection.branch_protection](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_protection) | resource |
| [github_issue_label.label](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/issue_label) | resource |
| [github_repository.repository](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository) | resource |
| [github_repository_autolink_reference.repository_autolink_reference](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_autolink_reference) | resource |
| [github_repository_collaborator.collaborator](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_collaborator) | resource |
| [github_repository_deploy_key.deploy_key](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_deploy_key) | resource |
| [github_repository_deploy_key.deploy_key_computed](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_deploy_key) | resource |
| [github_repository_project.repository_project](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_project) | resource |
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
| <a name="input_allow_update_branch"></a> [allow\_update\_branch](#input\_allow\_update\_branch) | (Optional) - Set to true to always suggest updating pull request branches. | `bool` | `null` | no |
| <a name="input_app_installations"></a> [app\_installations](#input\_app\_installations) | (Optional) A list of GitHub App IDs to be installed in this repository. | `set(string)` | `[]` | no |
| <a name="input_archive_on_destroy"></a> [archive\_on\_destroy](#input\_archive\_on\_destroy) | (Optional) Set to `false` to not archive the repository instead of deleting on destroy. | `string` | `true` | no |
| <a name="input_archived"></a> [archived](#input\_archived) | (Optional) Specifies if the repository should be archived. (Default: false) | `bool` | `false` | no |
| <a name="input_auto_init"></a> [auto\_init](#input\_auto\_init) | (Optional) Wether or not to produce an initial commit in the repository. (Default: true) | `bool` | `null` | no |
| <a name="input_autolink_references"></a> [autolink\_references](#input\_autolink\_references) | (Optional) Configuring autolink references. For details please check: https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_autolink_reference | <pre>list(object({<br>    key_prefix          = string<br>    target_url_template = string<br>  }))</pre> | `[]` | no |
| <a name="input_branch_protections"></a> [branch\_protections](#input\_branch\_protections) | (Optional) A list of v4 branch protections to apply to the repository. A map of `pattern` to branch protection config. | <pre>map(<br>    object(<br>      {<br>        enforce_admins                  = optional(bool, false)<br>        require_signed_commits          = optional(bool, false)<br>        required_linear_history         = optional(bool, false)<br>        require_conversation_resolution = optional(bool, false)<br>        required_status_checks = optional(object(<br>          {<br>            strict   = optional(bool)<br>            contexts = optional(list(string))<br>          }<br>        ))<br>        required_pull_request_reviews = optional(object(<br>          {<br>            dismiss_stale_reviews           = optional(bool)<br>            restrict_dismissals             = optional(bool)<br>            dismissal_restrictions          = optional(list(string))<br>            pull_request_bypassers          = optional(list(string))<br>            require_code_owner_reviews      = optional(bool)<br>            required_approving_review_count = optional(number)<br>            require_last_push_approval      = optional(bool)<br>          }<br>        ))<br>        restrict_pushes = optional(object(<br>          {<br>            blocks_creations = optional(bool)<br>            push_allowances  = optional(list(string))<br>          }<br>        ))<br>        force_push_bypassers = optional(list(string))<br>        allows_deletions     = optional(bool, false)<br>        allows_force_pushes  = optional(bool, false)<br>        lock_branch          = optional(bool, false)<br>      }<br>    )<br>  )</pre> | `{}` | no |
| <a name="input_branches"></a> [branches](#input\_branches) | (Optional) A list of branches to be created in this repository. | <pre>map(object({<br>    source_branch = optional(string)<br>    source_sha    = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_default_branch"></a> [default\_branch](#input\_default\_branch) | (Optional) The name of the default branch of the repository. | `string` | `null` | no |
| <a name="input_delete_branch_on_merge"></a> [delete\_branch\_on\_merge](#input\_delete\_branch\_on\_merge) | (Optional) Whether or not to delete the merged branch after merging a pull request. (Default: false) | `bool` | `null` | no |
| <a name="input_deploy_keys"></a> [deploy\_keys](#input\_deploy\_keys) | (Optional) Configure a deploy key ( SSH key ) that grants access to a single GitHub repository. This key is attached directly to the repository instead of to a personal user account. | `any` | `[]` | no |
| <a name="input_deploy_keys_computed"></a> [deploy\_keys\_computed](#input\_deploy\_keys\_computed) | (Optional) Configure a deploy key ( SSH key ) that grants access to a single GitHub repository. This key is attached directly to the repository instead of to a personal user account. | `any` | `[]` | no |
| <a name="input_description"></a> [description](#input\_description) | (Optional) A description of the repository. | `string` | `null` | no |
| <a name="input_encrypted_secrets"></a> [encrypted\_secrets](#input\_encrypted\_secrets) | (Optional) Configuring encrypted actions secrets. For details please check: https://www.terraform.io/docs/providers/github/r/actions_secret | `map(string)` | `{}` | no |
| <a name="input_gitignore_template"></a> [gitignore\_template](#input\_gitignore\_template) | (Optional) Use the name of the template without the extension. For example, Haskell. Available templates: https://github.com/github/gitignore | `string` | `null` | no |
| <a name="input_has_issues"></a> [has\_issues](#input\_has\_issues) | (Optional) Set to true to enable the GitHub Issues features on the repository. (Default: false) | `bool` | `null` | no |
| <a name="input_has_projects"></a> [has\_projects](#input\_has\_projects) | (Optional) Set to true to enable the GitHub Projects features on the repository. Per the github documentation when in an organization that has disabled repository projects it will default to false and will otherwise default to true. If you specify true when it has been disabled it will return an error.  (Default: false) | `bool` | `null` | no |
| <a name="input_has_wiki"></a> [has\_wiki](#input\_has\_wiki) | (Optional) Set to true to enable the GitHub Wiki features on the repository. (Default: false) | `bool` | `null` | no |
| <a name="input_homepage_url"></a> [homepage\_url](#input\_homepage\_url) | (Optional) The website of the repository. | `string` | `null` | no |
| <a name="input_is_template"></a> [is\_template](#input\_is\_template) | (Optional) Whether or not to tell GitHub that this is a template repository. ( Default: false) | `bool` | `null` | no |
| <a name="input_issue_labels"></a> [issue\_labels](#input\_issue\_labels) | (Optional) Configure a GitHub issue label resource. | <pre>list(object({<br>    name        = string<br>    description = string<br>    color       = string<br>  }))</pre> | `[]` | no |
| <a name="input_issue_labels_create"></a> [issue\_labels\_create](#input\_issue\_labels\_create) | (Optional) Specify whether you want to force or suppress the creation of issues labels. | `bool` | `null` | no |
| <a name="input_issue_labels_merge_with_github_labels"></a> [issue\_labels\_merge\_with\_github\_labels](#input\_issue\_labels\_merge\_with\_github\_labels) | (Optional) Specify if you want to merge and control githubs default set of issue labels. | `bool` | `null` | no |
| <a name="input_license_template"></a> [license\_template](#input\_license\_template) | (Optional) Use the name of the template without the extension. For example, 'mit' or 'mpl-2.0'. Available licences: https://github.com/github/choosealicense.com/tree/gh-pages/_licenses | `string` | `null` | no |
| <a name="input_maintain_collaborators"></a> [maintain\_collaborators](#input\_maintain\_collaborators) | (Optional) A list of users to add as collaborators granting them maintain permission. | `list(string)` | `[]` | no |
| <a name="input_maintain_team_ids"></a> [maintain\_team\_ids](#input\_maintain\_team\_ids) | (Optional) A list of teams (by id) to grant maintain permission to. | `list(string)` | `[]` | no |
| <a name="input_maintain_teams"></a> [maintain\_teams](#input\_maintain\_teams) | (Optional) A list of teams (by name/slug) to grant maintain permission to. | `list(string)` | `[]` | no |
| <a name="input_merge_commit_message"></a> [merge\_commit\_message](#input\_merge\_commit\_message) | Can be PR\_BODY, PR\_TITLE, or BLANK for a default merge commit message. Applicable only if allow\_merge\_commit is true. | `string` | `null` | no |
| <a name="input_merge_commit_title"></a> [merge\_commit\_title](#input\_merge\_commit\_title) | Can be PR\_TITLE or MERGE\_MESSAGE for a default merge commit title. Applicable only if allow\_merge\_commit is true. | `string` | `null` | no |
| <a name="input_module_depends_on"></a> [module\_depends\_on](#input\_module\_depends\_on) | (Optional) Define resources this module indirectly depends\_on. | `any` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the repository. | `string` | n/a | yes |
| <a name="input_pages"></a> [pages](#input\_pages) | (Optional) The repository's GitHub Pages configuration. (Default: {}) | <pre>object({<br>    source = optional(object({<br>      branch = string<br>      path   = optional(string)<br>    }), null)<br>    build_type = optional(string) # Can be `legacy` or `workflow`<br>    cname      = optional(string) # Can only be set after repository is created<br>  })</pre> | `null` | no |
| <a name="input_plaintext_secrets"></a> [plaintext\_secrets](#input\_plaintext\_secrets) | (Optional) Configuring actions secrets. For details please check: https://www.terraform.io/docs/providers/github/r/actions_secret | `map(string)` | `{}` | no |
| <a name="input_projects"></a> [projects](#input\_projects) | (Optional) Create and manage projects for GitHub repository. | <pre>list(object({<br>    name = string<br>    body = string<br>  }))</pre> | `[]` | no |
| <a name="input_pull_collaborators"></a> [pull\_collaborators](#input\_pull\_collaborators) | (Optional) A list of users to add as collaborators granting them pull (read-only) permission. | `list(string)` | `[]` | no |
| <a name="input_pull_team_ids"></a> [pull\_team\_ids](#input\_pull\_team\_ids) | (Optional) A list of teams (by id) to grant pull (read-only) permission to. | `list(string)` | `[]` | no |
| <a name="input_pull_teams"></a> [pull\_teams](#input\_pull\_teams) | (Optional) A list of teams (by name/slug) to grant pull (read-only) permission to. | `list(string)` | `[]` | no |
| <a name="input_push_collaborators"></a> [push\_collaborators](#input\_push\_collaborators) | (Optional) A list of users to add as collaborators granting them push (read-write) permission. | `list(string)` | `[]` | no |
| <a name="input_push_team_ids"></a> [push\_team\_ids](#input\_push\_team\_ids) | (Optional) A list of teams (by id) to grant push (read-write) permission to. | `list(string)` | `[]` | no |
| <a name="input_push_teams"></a> [push\_teams](#input\_push\_teams) | (Optional) A list of teams (by name/slug) to grant push (read-write) permission to. | `list(string)` | `[]` | no |
| <a name="input_squash_merge_commit_message"></a> [squash\_merge\_commit\_message](#input\_squash\_merge\_commit\_message) | (Optional) Can be PR\_BODY, COMMIT\_MESSAGES, or BLANK for a default squash merge commit message. Applicable only if allow\_squash\_merge is true. | `string` | `null` | no |
| <a name="input_squash_merge_commit_title"></a> [squash\_merge\_commit\_title](#input\_squash\_merge\_commit\_title) | (Optional) Can be PR\_TITLE or COMMIT\_OR\_PR\_TITLE for a default squash merge commit title. Applicable only if allow\_squash\_merge is true. | `string` | `null` | no |
| <a name="input_template"></a> [template](#input\_template) | (Optional) Template repository to use. (Default: {}) | <pre>object({<br>    owner                = string<br>    repository           = string<br>    include_all_branches = optional(bool, false)<br>  })</pre> | `null` | no |
| <a name="input_topics"></a> [topics](#input\_topics) | (Optional) The list of topics of the repository.  (Default: []) | `list(string)` | `null` | no |
| <a name="input_triage_collaborators"></a> [triage\_collaborators](#input\_triage\_collaborators) | (Optional) A list of users to add as collaborators granting them triage permission. | `list(string)` | `[]` | no |
| <a name="input_triage_team_ids"></a> [triage\_team\_ids](#input\_triage\_team\_ids) | (Optional) A list of teams (by id) to grant triage permission to. | `list(string)` | `[]` | no |
| <a name="input_triage_teams"></a> [triage\_teams](#input\_triage\_teams) | (Optional) A list of teams (by name/slug) to grant triage permission to. | `list(string)` | `[]` | no |
| <a name="input_variables"></a> [variables](#input\_variables) | (Optional) Configure action variables. For full details please check: https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_variable | `map(string)` | `{}` | no |
| <a name="input_visibility"></a> [visibility](#input\_visibility) | (Optional) Can be 'public', 'private' or 'internal' (GHE only). The visibility parameter overrides the private parameter. Defaults to 'private' if neither private nor visibility are set, default to state of private parameter if it is set. | `string` | `null` | no |
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
| <a name="output_projects"></a> [projects](#output\_projects) | A map of projects keyed by project input id. |
| <a name="output_repository"></a> [repository](#output\_repository) | All attributes and arguments as returned by the github\_repository resource. |
| <a name="output_secrets"></a> [secrets](#output\_secrets) | List of secrets available. |
| <a name="output_ssh_clone_url"></a> [ssh\_clone\_url](#output\_ssh\_clone\_url) | URL that can be provided to git clone to clone the repository via SSH. |
| <a name="output_webhooks"></a> [webhooks](#output\_webhooks) | All attributes and arguments as returned by the github\_repository\_webhook resource. |
<!-- END_TF_DOCS -->