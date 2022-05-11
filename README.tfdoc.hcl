header {
  image = "https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg"
  url   = "https://mineiros.io/?ref=terraform-github-repository"

  badge "build" {
    image = "https://github.com/mineiros-io/terraform-github-repository/workflows/CI/CD%20Pipeline/badge.svg"
    url   = "https://github.com/mineiros-io/terraform-github-repository/actions"
    text  = "Build Status"
  }

  badge "semver)" {
    image = "https://img.shields.io/github/v/tag/mineiros-io/terraform-github-repository.svg?label=latest&sort=semver"
    url   = "https://github.com/mineiros-io/terraform-github-repository/releases"
    text  = "GitHub tag (latest SemVer)"
  }

  badge "terraform" {
    image = "https://img.shields.io/badge/terraform-1.x-623CE4.svg?logo=terraform"
    url   = "https://github.com/hashicorp/terraform/releases"
    text  = "Terraform Version"
  }

  badge "tf-gh" {
    image = "https://img.shields.io/badge/GH-4.10+-F8991D.svg?logo=terraform"
    url   = "https://github.com/terraform-providers/terraform-provider-github/releases"
    text  = "Github Provider Version"
  }

  badge "slack" {
    image = "https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack"
    url   = "https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg"
    text  = "Join Slack"
  }
}

section {
  title   = "terraform-github-repository"
  toc     = true
  content = <<-END
    A [Terraform] module for creating a public or private repository on [Github].

    **_This module supports Terraform v1.x and is compatible with the Official Terraform GitHub Provider v4.10 and above from `integrations/github`._**

    **Attention: This module is incompatible with the Hashicorp GitHub Provider! The latest version of this module supporting `hashicorp/github` provider is `~> 0.10.0`**

    _Security related notice: Versions 4.7.0, 4.8.0, 4.9.0 and 4.9.1 of the Terraform Github Provider are deny-listed in version constraints as a regression introduced in 4.7.0 and fixed in 4.9.2 creates public repositories from templates even if visibility is set to private._
  END

  section {
    title   = "Module Features"
    content = <<-END
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
        Projects,
        Repository Webhooks

      - _Features not yet implemented_:
        Project Columns support,
        Actions,
        Repository File
    END
  }

  section {
    title   = "Getting Started"
    content = <<-END
      Most basic usage creating a new private github repository.

      ```hcl
      module "repository" {
        source  = "mineiros-io/repository/github"
        version = "~> 0.16.0"

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
    END
  }

  section {
    title   = "Module Argument Reference"
    content = <<-END
      See [variables.tf] and [examples/] for details and use-cases.
    END

    section {
      title = "Main Resource Configuration"

      variable "name" {
        required    = true
        type        = string
        description = <<-END
          The name of the repository.
        END
      }

      variable "defaults" {
        type        = object(defaults)
        default     = {}
        description = <<-END
          A object of default settings to use instead of module defaults for top-level arguments.
          See below for a list of supported arguments.

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
          `allow_auto_merge`,
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
        END
      }

      variable "pages" {
        type        = object(pages)
        default     = {}
        description = <<-END
          A object of settings to configure GitHub Pages in this repository.
          See below for a list of supported arguments.
        END

        attribute "branch" {
          required    = true
          type        = string
          description = <<-END
            The repository branch used to publish the site's source files.
          END
        }

        attribute "path" {
          type        = string
          description = <<-END
            The repository directory from which the site publishes.
          END
        }

        attribute "cname" {
          type        = string
          description = <<-END
            The custom domain for the repository. This can only be set after the
            repository has been created.
          END
        }
      }

      variable "allow_merge_commit" {
        type        = bool
        default     = true
        description = <<-END
          Set to `false` to disable merge commits on the repository.
          If you set this to `false` you have to enable either `allow_squash_merge`
          or `allow_rebase_merge`.
        END
      }

      variable "allow_squash_merge" {
        type        = bool
        default     = false
        description = <<-END
          Set to `true` to enable squash merges on the repository.
        END
      }

      variable "allow_rebase_merge" {
        type        = bool
        default     = false
        description = <<-END
          Set to `true` to enable rebase merges on the repository.
        END
      }

      variable "allow_auto_merge" {
        type        = bool
        default     = false
        description = <<-END
          Set to `true`  to allow [auto-merging](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/incorporating-changes-from-a-pull-request/automatically-merging-a-pull-request)
          pull requests on the repository. If you enable auto-merge for a pull
          request, the pull request will merge automatically when all required
          reviews are met and status checks have passed.
        END
      }

      variable "description" {
        type        = string
        default     = ""
        description = <<-END
          A description of the repository.
        END
      }

      variable "delete_branch_on_merge" {
        type        = bool
        default     = true
        description = <<-END
          Set to `false` to disable the automatic deletion of head branches after pull requests are merged.
        END
      }

      variable "homepage_url" {
        type        = string
        default     = ""
        description = <<-END
          URL of a page describing the project.
        END
      }

      variable "private" {
        type        = bool
        description = <<-END
          **_DEPRECATED_**: Please use `visibility` instead and update your code. parameter will be removed in a future version
        END
      }

      variable "visibility" {
        type        = string
        default     = "private"
        description = <<-END
          Can be `public` or `private`.
          If your organization is associated with an enterprise account using GitHub Enterprise Cloud or GitHub Enterprise Server 2.20+, `visibility` can also be `internal`.
          The `visibility` parameter overrides the deprecated `private` parameter.
        END
      }

      variable "has_issues" {
        type        = bool
        default     = false
        description = <<-END
          Set to true to enable the GitHub Issues features on the repository.
        END
      }

      variable "has_projects" {
        type        = bool
        default     = false
        description = <<-END
          Set to true to enable the GitHub Projects features on the repository.
        END
      }

      variable "has_wiki" {
        type        = bool
        default     = false
        description = <<-END
          Set to true to enable the GitHub Wiki features on the repository.
        END
      }

      variable "has_downloads" {
        type        = bool
        default     = false
        description = <<-END
          Set to `true` to enable the (deprecated) downloads features on the repository.
        END
      }

      variable "is_template" {
        type        = bool
        default     = false
        description = <<-END
          Set to `true` to tell GitHub that this is a template repository.
        END
      }

      variable "default_branch" {
        type        = string
        default     = ""
        description = <<-END
          The name of the default branch of the repository.
          NOTE: The configured default branch must exist in the repository.
          If the branch doesn't exist yet, or if you are creating a new
          repository, please add the desired default branch to the `branches`
          variable, which will cause Terraform to create it for you.
        END
      }

      variable "archived" {
        type        = bool
        default     = false
        description = <<-END
          Specifies if the repository should be archived.
          NOTE: Currently, the API does not support unarchiving.
        END
      }

      variable "topics" {
        type        = list(string)
        default     = []
        description = <<-END
          The list of topics of the repository.
        END
      }

      variable "extra_topics" {
        type        = list(string)
        default     = []
        description = <<-END
          A list of additional topics of the repository. Those topics will be added to the list of `topics`. This is useful if `default.topics` are used and the list should be extended with more topics.
        END
      }

      variable "vulnerability_alerts" {
        type        = bool
        description = <<-END
          Set to `false` to disable security alerts for vulnerable dependencies.
          Enabling requires alerts to be enabled on the owner level.
        END
      }

      variable "archive_on_destroy" {
        type        = bool
        default     = true
        description = <<-END
          Set to `false` to not archive the repository instead of deleting on destroy.
        END
      }
    }

    section {
      title = "Extended Resource Configuration"

      section {
        title   = "Repository Creation Configuration"
        content = <<-END
          The following four arguments can only be set at repository creation and
          changes will be ignored for repository updates and
          will not show a diff in plan or apply phase.
        END

        variable "auto_init" {
          type        = bool
          default     = true
          description = <<-END
            Set to `false` to not produce an initial commit in the repository.
          END
        }

        variable "gitignore_template" {
          type        = string
          default     = ""
          description = <<-END
            Use the name of the template without the extension.
          END
        }

        variable "license_template" {
          type        = string
          default     = ""
          description = <<-END
            Use the name of the template without the extension.
          END
        }

        variable "template" {
          type        = object(template)
          default     = {}
          description = <<-END
            Use a template repository to create this resource.
          END

          attribute "owner" {
            required    = true
            type        = string
            description = <<-END
              The GitHub organization or user the template repository is owned by.
            END
          }

          attribute "repository" {
            required    = true
            type        = string
            description = <<-END
              The name of the template repository.
            END
          }
        }
      }

      section {
        title   = "Teams Configuration"
        content = <<-END
          Your can use non-computed (known at `terraform plan`) team names or slugs (`*_teams` Attributes)
          or computed (only known in `terraform apply` phase) team IDs (`*_team_ids` Attributes).
          **When using non-computed names/slugs teams need to exist before running plan.**
          This is due to some terraform limitation and we will update the module once terraform removed this limitation.
        END

        variable "pull_teams" {
          type        = list(string)
          default     = []
          description = <<-END
            Can also be `pull_team_ids`. A list of teams to grant pull (read-only) permission.
            Recommended for non-code contributors who want to view or discuss your project.
          END
        }

        variable "triage_teams" {
          type        = list(string)
          default     = []
          description = <<-END
            Can also be `triage_team_ids`. A list of teams to grant triage permission.
            Recommended for contributors who need to proactively manage issues and pull requests
            without write access.
          END
        }

        variable "push_teams" {
          type        = list(string)
          default     = []
          description = <<-END
            Can also be `push_team_ids`. A list of teams to grant push (read-write) permission.
            Recommended for contributors who actively push to your project.
          END
        }

        variable "maintain_teams" {
          type        = list(string)
          default     = []
          description = <<-END
            Can also be `maintain_team_ids`. A list of teams to grant maintain permission.
            Recommended for project managers who need to manage the repository without access to sensitive or destructive actions.
          END
        }

        variable "admin_teams" {
          type        = list(string)
          default     = []
          description = <<-END
            Can also be `admin_team_ids`. A list of teams to grant admin (full) permission.
            Recommended for people who need full access to the project, including sensitive and destructive actions like managing security or deleting a repository.
          END
        }
      }

      section {
        title = "Collaborator Configuration"

        variable "pull_collaborators" {
          type        = list(string)
          default     = []
          description = <<-END
            A list of user names to add as collaborators granting them pull (read-only) permission.
            Recommended for non-code contributors who want to view or discuss your project.
          END
        }

        variable "triage_collaborators" {
          type        = list(string)
          default     = []
          description = <<-END
            A list of user names to add as collaborators granting them triage permission.
            Recommended for contributors who need to proactively manage issues and pull requests without write access.
          END
        }

        variable "push_collaborators" {
          type        = list(string)
          default     = []
          description = <<-END
            A list of user names to add as collaborators granting them push (read-write) permission.
            Recommended for contributors who actively push to your project.
          END
        }

        variable "maintain_collaborators" {
          type        = list(string)
          default     = []
          description = <<-END
            A list of user names to add as collaborators granting them maintain permission.
            Recommended for project managers who need to manage the repository without access to sensitive or destructive actions.
          END
        }

        variable "admin_collaborators" {
          type        = list(string)
          default     = []
          description = <<-END
            A list of user names to add as collaborators granting them admin (full) permission.
            Recommended for people who need full access to the project, including sensitive and destructive actions like managing security or deleting a repository.
          END
        }
      }

      section {
        title = "Branches Configuration"

        variable "branches" {
          type        = list(branch)
          default     = []
          description = <<-END
            Create and manage branches within your repository.
            Additional constraints can be applied to ensure your branch is created from another branch or commit.
          END

          attribute "name" {
            required    = true
            type        = string
            description = <<-END
              The name of the branch to create.
            END
          }

          attribute "source_branch" {
            type        = string
            description = <<-END
              The branch name to start from. Uses the configured default branch per default.
            END
          }

          attribute "source_sha" {
            type        = bool
            default     = true
            description = <<-END
              The commit hash to start from. Defaults to the tip of `source_branch`. If provided, `source_branch` is ignored.
            END
          }
        }
      }

      section {
        title = "Deploy Keys Configuration"

        variable "deploy_keys" {
          type        = list(deploy_key)
          default     = []
          description = <<-END
            Can also be type `list(string)`. Specifies deploy keys and access-level of deploy keys used in this repository.
            Every `string` in the list will be converted internally into the `object` representation with the `key` argument being set to the `string`. `object` details are explained below.
          END

          attribute "key" {
            required    = true
            type        = string
            description = <<-END
              The SSH public key.
            END
          }

          attribute "title" {
            type        = string
            description = <<-END
              A Title for the key.
              Default is the comment field of SSH public key if it is not empty else it defaults to `md5(key)`.
            END
          }

          attribute "read_only" {
            type        = bool
            default     = true
            description = <<-END
              Specifies the level of access for the key.
            END
          }

          attribute "id" {
            type        = string
            default     = "md5(key)"
            description = <<-END
              Specifies an ID which is used to prevent resource recreation when the order in the list of deploy keys changes.
              The ID must be unique between `deploy_keys` and `deploy_keys_computed`.
            END
          }
        }

        variable "deploy_keys_computed" {
          type        = list(deploy_key)
          default     = []
          description = <<-END
            Can also be type `string`. Same as `deploy_keys` argument with the following differences:
            Use this argument if you depend on computed keys that terraform can not use in resource `for_each` execution. Downside of this is the recreation of deploy key resources whenever the order in the list changes. **Prefer `deploy_keys` whenever possible.**
            This argument does **not** conflict with `deploy_keys` and should exclusively be used for computed resources.
          END

          attribute "key" {
            required    = true
            type        = string
            description = <<-END
              The SSH public key.
            END
          }

          attribute "title" {
            type        = string
            description = <<-END
              A Title for the key.
              Default is the comment field of SSH public key if it is not empty else it defaults to `md5(key)`.
            END
          }

          attribute "read_only" {
            type        = bool
            default     = true
            description = <<-END
              Specifies the level of access for the key.
            END
          }

          attribute "id" {
            type        = string
            default     = "md5(key)"
            description = <<-END
              Specifies an ID which is used to prevent resource recreation when the order in the list of deploy keys changes.
              The ID must be unique between `deploy_keys` and `deploy_keys_computed`.
            END
          }
        }
      }

      section {
        title = "Branch Protections Configuration"

        variable "branch_protections_v3" {
          type        = list(branch_protection_v3)
          default     = []
          description = <<-END
            This resource allows you to configure branch protection for repositories in your organization.
            When applied, the branch will be protected from forced pushes and deletion.
            Additional constraints, such as required status checks or restrictions on users and teams, can also be configured.
          END

          attribute "branch" {
            required    = true
            type        = string
            description = <<-END
              The Git branch to protect.
            END
          }

          attribute "enforce_admins" {
            type        = bool
            default     = false
            description = <<-END
              Setting this to true enforces status checks for repository administrators.
            END
          }

          attribute "require_conversation_resolution" {
            type        = bool
            default     = false
            description = <<-END
              Setting this to true requires all conversations to be resolved.
            END
          }

          attribute "require_signed_commits" {
            type        = bool
            default     = false
            description = <<-END
              Setting this to true requires all commits to be signed with GPG.
            END
          }

          attribute "required_status_checks" {
            type        = object(required_status_checks)
            default     = {}
            description = <<-END
              Enforce restrictions for required status checks.
              See Required Status Checks below for details.
            END

            attribute "strict" {
              type        = bool
              default     = false
              description = <<-END
                Require branches to be up to date before merging.
              END
            }

            attribute "contexts" {
              type        = list(string)
              default     = []
              description = <<-END
                The list of status checks to require in order to merge into this branch. If default is `[]` no status checks are required.
              END
            }
          }

          attribute "required_pull_request_reviews" {
            type        = object(required_pull_request_reviews)
            default     = {}
            description = <<-END
              Enforce restrictions for pull request reviews.
            END

            attribute "dismiss_stale_reviews" {
              type        = bool
              default     = true
              description = <<-END
                Dismiss approved reviews automatically when a new commit is pushed.
              END
            }

            attribute "dismissal_users" {
              type        = list(string)
              default     = []
              description = <<-END
                The list of user logins with dismissal access
              END
            }

            attribute "dismissal_teams" {
              type        = list(string)
              default     = []
              description = <<-END
                The list of team slugs with dismissal access.
                Always use slug of the team, not its name.
                Each team already has to have access to the repository.
              END
            }

            attribute "require_code_owner_reviews" {
              type        = bool
              default     = false
              description = <<-END
                Require an approved review in pull requests including files with a designated code owner.
              END
            }
          }

          attribute "restrictions" {
            type        = object(restrictions)
            default     = {}
            description = <<-END
              Enforce restrictions for the users and teams that may push to the branch - only available for organization-owned repositories. See Restrictions below for details.
            END

            attribute "users" {
              type        = list(string)
              default     = []
              description = <<-END
                The list of user logins with push access.
              END
            }

            attribute "teams" {
              type        = list(string)
              default     = []
              description = <<-END
                The list of team slugs with push access.
                Always use slug of the team, not its name.
                Each team already has to have access to the repository.
              END
            }

            attribute "apps" {
              type        = list(string)
              default     = []
              description = <<-END
                The list of app slugs with push access.
              END
            }
          }
        }

        variable "branch_protections" {
          type        = list(branch_protection_v3)
          default     = []
          description = <<-END
            **_DEPRECATED_** To ensure compatibility with future versions of this module, please use `branch_protections_v3`.
            This argument is ignored if `branch_protections_v3` is used. Please see `branch_protections_v3` for supported attributes.
          END
        }
      }

      section {
        title = "Issue Labels Configuration"

        variable "issue_labels" {
          type        = list(issue_label)
          default     = []
          description = <<-END
            This resource allows you to create and manage issue labels within your GitHub organization.
            Issue labels are keyed off of their "name", so pre-existing issue labels result in a 422 HTTP error if they exist outside of Terraform.
            Normally this would not be an issue, except new repositories are created with a "default" set of labels, and those labels easily conflict with custom ones.
            This resource will first check if the label exists, and then issue an update, otherwise it will create.
          END

          attribute "name" {
            required    = true
            type        = string
            description = <<-END
              The name of the label.
            END
          }

          attribute "color" {
            required    = true
            type        = string
            description = <<-END
              A 6 character hex code, without the leading `#`, identifying the color of the label.
            END
          }

          attribute "description" {
            type        = string
            default     = ""
            description = <<-END
              A short description of the label.
            END
          }

          attribute "id" {
            type        = string
            default     = "name"
            description = <<-END
              Specifies an ID which is used to prevent resource recreation when the order in the list of issue labels changes.
            END
          }
        }

        variable "issue_labels_merge_with_github_labels" {
          type        = bool
          description = <<-END
            Specify if github default labels will be handled by terraform. This should be decided on upon creation of the repository. If you later decide to disable this feature, github default labels will be destroyed if not replaced by labels set in `issue_labels` argument.
          END
        }

        variable "issue_labels_create" {
          type        = bool
          description = <<-END
            Specify whether you want to force or suppress the creation of issues labels.
            Default is `true` if `has_issues` is `true` or `issue_labels` is non-empty.
          END
        }
      }

      section {
        title = "Projects Configuration"

        variable "projects" {
          type        = list(project)
          default     = []
          description = <<-END
            This resource allows you to create and manage projects for GitHub repository.
          END

          attribute "name" {
            required    = true
            type        = string
            description = <<-END
              The name of the project.
            END
          }

          attribute "body" {
            type        = string
            default     = ""
            description = <<-END
              The body of the project.
            END
          }

          attribute "id" {
            type        = string
            default     = "name"
            description = <<-END
              Specifies an ID which is used to prevent resource recreation when the order in the list of projects changes.
            END
          }
        }
      }

      section {
        title = "Webhooks Configuration"

        variable "webhooks" {
          type        = list(webhook)
          default     = []
          description = <<-END
            This resource allows you to create and manage webhooks for repositories in your organization.
            When applied, a webhook will be created which specifies a URL to receive events and which events to receieve. Additional constraints, such as SSL verification, pre-shared secret and content type can also be configured
          END

          attribute "events" {
            required    = true
            type        = list(string)
            description = <<-END
              A list of events which should trigger the webhook. [See a list of available events.](https://developer.github.com/v3/activity/events/types/)
            END
          }

          attribute "url" {
            required    = true
            type        = string
            description = <<-END
              The URL to which the payloads will be delivered.
            END
          }

          attribute "active" {
            type        = bool
            description = <<-END
              Indicate if the webhook should receive events. Defaults to `true`.
            END
          }

          attribute "content_type" {
            type        = string
            default     = "form"
            description = <<-END
              The media type used to serialize the payloads. Supported values include `json` and `form`.
            END
          }

          attribute "secret" {
            type        = string
            description = <<-END
              If provided, the `secret` will be used as the `key` to generate the HMAC hex digest value in the [X-Hub-Signature](https://developer.github.com/webhooks/#delivery-headers) header.
            END
          }

          attribute "insecure_ssl" {
            type        = bool
            description = <<-END
              Determines whether the SSL certificate of the host for `url` will be verified when delivering payloads. Supported values include `0` (verification is performed) and `1` (verification is not performed). The default is `0`. **We strongly recommend not setting this to `1` as you are subject to man-in-the-middle and other attacks.**
            END
          }
        }
      }

      section {
        title = "Secrets Configuration"

        variable "plaintext_secrets" {
          type        = map(string)
          default     = {}
          description = <<-END
            This map allows you to create and manage secrets for repositories in your organization.

            Each element in the map is considered a secret to be managed, being the key map the secret name and the value the corresponding secret in plain text:

            When applied, a secret with the given key and value will be created in the repositories.

            The value of the secrets must be given in plain text, GitHub provider is in charge of encrypting it.

            **Attention:** You should treat state as sensitive always. It is also advised that you do not store plaintext values in your code but rather populate the encrypted_value using fields from a resource, data source or variable as, while encrypted in state, these will be easily accessible in your code. See below for an example of this abstraction.
          END

          readme_example = <<-END
            plaintext_secrets = {
              SECRET_NAME_1 = "plaintext_secret_value_1"
              SECRET_NAME_2 = "plaintext_secret_value_2"
            }
          END
        }

        variable "encrypted_secrets" {
          type        = map(string)
          default     = {}
          description = <<-END
            This map allows you to create and manage encrypted secrets for repositories in your organization.

            Each element in the map is considered a secret to be managed, being the key map the secret name and the value the corresponding encrypted value of the secret using the Github public key in Base64 format.b

            When applied, a secret with the given key and value will be created in the repositories.
          END

          readme_example = <<-END
            encrypted_secrets = {
              SECRET_NAME_1 = "c2VjcmV0X3ZhbHVlXzE="
              SECRET_NAME_2 = "c2VjcmV0X3ZhbHVlXzI="
            }
          END
        }

        variable "required_approving_review_count" {
          type        = number
          description = <<-END
            Require x number of approvals to satisfy branch protection requirements.
            If this is specified it must be a number between 1-6.
            This requirement matches Github's API, see the upstream documentation for more information.
            Default is no approving reviews are required.
          END
        }
      }

      section {
        title = "Autolink References Configuration"

        variable "autolink_references" {
          type        = list(autolink_reference)
          default     = []
          description = <<-END
              This resource allows you to create and manage autolink references for GitHub repository.
            END

          attribute "key_prefix" {
            required    = true
            type        = string
            description = <<-END
                This prefix appended by a number will generate a link any time it is found in an issue, pull request, or commit.
              END
          }

          attribute "target_url_template" {
            required    = true
            type        = string
            description = <<-END
                The template of the target URL used for the links; must be a valid URL and contain `<num>` for the reference number.
              END
          }
        }
      }

      section {
        title = "App Installations"

        variable "app_installations" {
          type        = set(string)
          default     = {}
          description = <<-END
            A set of GitHub App IDs to be installed in this repository.
          END

          readme_example = <<-END
            app_installations = ["05405144", "12556423"]
          END
        }
      }
    }

    section {
      title = "Module Configuration"

      variable "module_depends_on" {
        type        = list(dependency)
        default     = []
        description = <<-END
          Due to the fact, that terraform does not offer `depends_on` on modules as of today (v0.12.24)
          we might hit race conditions when dealing with team names instead of ids.
          So when using the feature of [adding teams by slug/name](#teams-configuration) to the repository when creating it,
          make sure to add all teams to this list as indirect dependencies.
        END
      }
    }
  }

  section {
    title   = "Module Outputs"
    content = <<-END
      The following attributes are exported by the module:
    END

    output "repository" {
      type        = object(repository)
      description = <<-END
        All repository attributes as returned by the [`github_repository`]
        resource containing all arguments as specified above and the other
        attributes as specified below.
      END
    }

    output "branches" {
      type        = object(branches)
      description = <<-END
        All repository attributes as returned by the [`github_branch`]
        resource containing all arguments as specified above and the other
        attributes as specified below.
      END
    }

    output "full_name" {
      type        = string
      description = <<-END
        A string of the form "orgname/reponame".
      END
    }

    output "html_url" {
      type        = string
      description = <<-END
        URL to the repository on the web.
      END
    }

    output "ssh_clone_url" {
      type        = string
      description = <<-END
        URL that can be provided to git clone to clone the repository via SSH.
      END
    }

    output "http_clone_url" {
      type        = string
      description = <<-END
        URL that can be provided to git clone to clone the repository via HTTPS.
      END
    }

    output "git_clone_url" {
      type        = string
      description = <<-END
        URL that can be provided to git clone to clone the repository
        anonymously via the git protocol.
      END
    }

    output "collaborators" {
      type        = object(collaborators)
      description = <<-END
        A map of Collaborator objects keyed by the `name` of the collaborator as
        returned by the [`github_repository_collaborator`] resource.
      END
    }

    output "deploy_keys" {
      type        = object(deploy_keys)
      description = <<-END
        A merged map of deploy key objects for the keys originally passed via
        `deploy_keys` and `deploy_keys_computed` as returned by the
        [`github_repository_deploy_key`] resource keyed by the input `id` of the
        key.
      END
    }

    output "projects" {
      type        = object(project)
      description = <<-END
        A map of Project objects keyed by the `id` of the project as returned by
        the [`github_repository_project`] resource
      END
    }

    output "issue_labels" {
      type        = object(issue_label)
      description = <<-END
        A map of issue labels keyed by label input id or name.
      END
    }

    output "webhooks" {
      type        = object(webhook)
      description = <<-END
        All attributes and arguments as returned by the
        `github_repository_webhook` resource.
      END
    }

    output "secrets" {
      type        = object(secret)
      description = <<-END
        List of secrets available.
      END
    }

    output "app_installations" {
      type        = set(number)
      description = <<-END
        A map of deploy app installations keyed by installation id.
      END
    }
  }

  section {
    title = "External Documentation"

    section {
      title   = "Terraform Github Provider Documentation"
      content = <<-END
        - https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository
        - https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch
        - https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_collaborator
        - https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_deploy_key
        - https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_project
        - https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_autolink_reference
      END
    }
  }

  section {
    title   = "Module Versioning"
    content = <<-END
      This Module follows the principles of [Semantic Versioning (SemVer)].

      Given a version number `MAJOR.MINOR.PATCH`, we increment the:

      1. `MAJOR` version when we make incompatible changes,
      2. `MINOR` version when we add functionality in a backwards compatible manner, and
      3. `PATCH` version when we make backwards compatible bug fixes.
    END

    section {
      title   = "Backwards compatibility in `0.0.z` and `0.y.z` version"
      content = <<-END
        - Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
        - Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)
      END
    }
  }

  section {
    title   = "About Mineiros"
    content = <<-END
      [Mineiros][homepage] is a remote-first company headquartered in Berlin, Germany
      that solves development, automation and security challenges in cloud infrastructure.

      Our vision is to massively reduce time and overhead for teams to manage and
      deploy production-grade and secure cloud infrastructure.

      We offer commercial support for all of our modules and encourage you to reach out
      if you have any questions or need help. Feel free to email us at [hello@mineiros.io] or join our
      [Community Slack channel][slack].
    END
  }

  section {
    title   = "Reporting Issues"
    content = <<-END
      We use GitHub [Issues] to track community reported issues and missing features.
    END
  }

  section {
    title   = "Contributing"
    content = <<-END
      Contributions are always encouraged and welcome! For the process of accepting changes, we use
      [Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].
    END
  }

  section {
    title   = "Makefile Targets"
    content = <<-END
      This repository comes with a handy [Makefile].
      Run `make help` to see details on each available target.
    END
  }

  section {
    title   = "License"
    content = <<-END
      [![license][badge-license]][apache20]

      This module is licensed under the Apache License Version 2.0, January 2004.
      Please see [LICENSE] for full details.

      Copyright &copy; 2020-2022 [Mineiros GmbH][homepage]
    END
  }
}

references {
  ref "github" {
    value = "https://github.com/"
  }
  ref "`github_repository`" {
    value = "https://www.terraform.io/docs/providers/github/r/repository.html#attributes-reference"
  }
  ref "`github_repository_collaborator`" {
    value = "https://www.terraform.io/docs/providers/github/r/repository_collaborator.html#attribute-reference"
  }
  ref "`github_repository_deploy_key`" {
    value = "https://www.terraform.io/docs/providers/github/r/repository_deploy_key.html#attributes-reference"
  }
  ref "`github_repository_project`" {
    value = "https://www.terraform.io/docs/providers/github/r/repository_project.html#attributes-reference"
  }
  ref "`github_repository_autolink_reference`" {
    value = "https://www.terraform.io/docs/providers/github/r/repository_autolink_reference.html#attributes-reference"
  }
  ref "homepage" {
    value = "https://mineiros.io/?ref=terraform-github-repository"
  }
  ref "hello@mineiros.io" {
    value = "mailto:hello@mineiros.io"
  }
  ref "badge-build" {
    value = "https://github.com/mineiros-io/terraform-github-repository/workflows/CI/CD%20Pipeline/badge.svg"
  }
  ref "badge-semver" {
    value = "https://img.shields.io/github/v/tag/mineiros-io/terraform-github-repository.svg?label=latest&sort=semver"
  }
  ref "badge-license" {
    value = "https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg"
  }
  ref "badge-terraform" {
    value = "https://img.shields.io/badge/terraform-1.x-623CE4.svg?logo=terraform"
  }
  ref "badge-slack" {
    value = "https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack"
  }
  ref "badge-tf-gh" {
    value = "https://img.shields.io/badge/GH-4.10+-F8991D.svg?logo=terraform"
  }
  ref "releases-github-provider" {
    value = "https://github.com/terraform-providers/terraform-provider-github/releases"
  }
  ref "build-status" {
    value = "https://github.com/mineiros-io/terraform-github-repository/actions"
  }
  ref "releases-github" {
    value = "https://github.com/mineiros-io/terraform-github-repository/releases"
  }
  ref "releases-terraform" {
    value = "https://github.com/hashicorp/terraform/releases"
  }
  ref "apache20" {
    value = "https://opensource.org/licenses/Apache-2.0"
  }
  ref "slack" {
    value = "https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg"
  }
  ref "terraform" {
    value = "https://www.terraform.io"
  }
  ref "aws" {
    value = "https://aws.amazon.com/"
  }
  ref "semantic versioning (semver)" {
    value = "https://semver.org/"
  }
  ref "variables.tf" {
    value = "https://github.com/mineiros-io/terraform-github-repository/blob/main/variables.tf"
  }
  ref "examples/" {
    value = "https://github.com/mineiros-io/terraform-github-repository/blob/main/examples"
  }
  ref "issues" {
    value = "https://github.com/mineiros-io/terraform-github-repository/issues"
  }
  ref "license" {
    value = "https://github.com/mineiros-io/terraform-github-repository/blob/main/LICENSE"
  }
  ref "makefile" {
    value = "https://github.com/mineiros-io/terraform-github-repository/blob/main/Makefile"
  }
  ref "pull requests" {
    value = "https://github.com/mineiros-io/terraform-github-repository/pulls"
  }
  ref "contribution guidelines" {
    value = "https://github.com/mineiros-io/terraform-github-repository/blob/main/CONTRIBUTING.md"
  }
}
