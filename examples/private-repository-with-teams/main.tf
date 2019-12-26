terraform {
  required_version = ">= 0.12"
}

provider "github" {
  token        = var.github_token
  organization = var.github_organization
}

module "repository" {
  source = "../../modules/repository"

  name               = "test-repository3"
  description        = "A repository created with terraform to test the terraform-github-repository module."
  homepage_url       = "https://github.com/mineiros-io"
  private            = true
  has_issues         = true
  has_projects       = true
  has_wiki           = true
  allow_merge_commit = true
  allow_rebase_merge = true
  allow_squash_merge = true
  has_downloads      = false
  auto_init          = true
  gitignore_template = "Terraform"
  license_template   = "mit"
  archived           = false
  topics             = ["terrform", "integration-test"]

  teams = [
    {
      id         = module.team.id
      permission = "admin"
    }
  ]

  branch_protection_rules = [
    {
      branch                 = "master"
      enforce_admins         = true
      require_signed_commits = true

      required_status_checks = {
        strict   = true
        contexts = ["ci/travis"]
      }

      required_pull_request_reviews = {
        dismiss_stale_reviews           = true
        dismissal_users                 = ["soerenmartius"]
        dismissal_teams                 = [module.team.slug]
        require_code_owner_reviews      = true
        required_approving_review_count = 1
      }

      restrictions = {
        users = ["terraform-test-user-1"]
        teams = ["team-1"]
      }
    }
  ]

  issue_labels = [
    {
      name        = "WIP"
      description = "Work in Progress..."
      color       = "d6c860"
    },
    {
      name        = "another-label"
      description = "This is a lable created by Terraform..."
      color       = "1dc34f"
    }
  ]

  deploy_keys = [
    {
      title     = "CI User Deploy Key"
      key       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCjv+wDq3BV0CTTIJYCnUv530ximNPwfrILIXRhhTZNPrDTpxYCO2ACexeX4wN1vfQqsSXwKutdBJoL42kXYHGRpEQ/1iiojJYL3wO7ktdeQuWDEhTyMzOp0FPrEWydzhCXKqcsA+RVPBAwXlsmaw7SkvjVgR9JCNC3OuIoPndMDSeT64/LHMX8UDlS+PikVRZ5rXhOI50Mqijd+xNf55hxURG3Zp1/iIjWCBHZQLOaazd09MD+HB9Hm/df8l6Mo4ahZuJFYfESIt8lR0FfKkfz4FDPil4JcK1BUs2013c4PYyt8JQR08dUIOGBQNe5mhLPJHD0+ylbQJown5Ahs+Nq5aX+1ZrpXlSO5KSsOKlq/Sj2uYyODWhhKuXlCaEU1eQcREhjP0KEx5AVcFCH3rxSC1gTp8w5fEuOeM3As0BPeo/LqLrtQcXnOZpYn/LGlcZE420YP8nfbMZ6I71KSn0+TjnUWQV93r+UMYmfjHwlq14pgPfWmi+nT/4g1n8WAR7VAKv/7fdY/e2gv5w22El1bXSvP+4fH86s+g/gGfxnjVhRB/CgxfrftyzBZOEXGQEGbiY2rJcLbdi2WY6i9rBQkEWCX8ExOK4HYLZ2qbw6jStl+yHDLgUbhwoe7ggzs5mReaMVcU0MQ6PRDJJ+AyI3bledoYFF+h8M8p2afcb3aw=="
      read_only = true
    },
    {
      title     = "Test Key"
      key       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC7IF88OLL8j1bTvRCernM/J45aoQvOaHNTDkBnMpxWUsf+F3ZBy/ls8yOgeF+OAFCT3tPrh2drGa3cK460/zL2SxAn5mT1bcDJOk7axMcamZ0EpKWAaSbRKxCLkUsTbHiW0nHG+jT7PQCtWwx6CQNh5ztx+Ge5QwDgS7HpyMxIS5Ju4dt5Eh2+MaPMjKWd8P5FKqNCvO4VYy+/3RijeQO+6lM9rih3EECkLug44ZKtbSmQhjHS5/iY7TkfpFpOgMVprgTq5tEK13wrhgjDO5gZ+MopTv5jmuatBLUlpjVI64EHm+zPyxn5E/vehopX8uF1yM1dTt4t6t+p0SRmaCSIX6QOJt9LUmIjrHvseC/TCU8Bfv//QM3GhuaSd1YtbTxbni7R4YX8EKLuBK3bidAj1c9130aML89ckztI9RAiRj+oYyqZqoj1bNG0x1D7XFjyaLf+V+yVrACx/h3PvpG2/dNQ06PRdqAq33dQ7gfsI0qw5QnOCEZimbNigOUuqxf33k2hNkjZCyTXRHhslaY4LoOCIJZrC9dr+a4ENgWw0gVOsuP+Lr6I5UBR4B/H9PtvqAcRjpUOAoJYJiCPgWlglIyuV80u9Uwk11X09E09zEiW+CJWi4RHDWhRNcWO0z5o4nPbEExnXqpiVGPn+WOCsagpap0WXUErrCGhzwuHkQ=="
      read_only = false
    }
  ]

  projects = [
    {
      name = "Testproject"
      body = "This is a fancy test project for testing"
    },
    {
      name = "Another Testproject"
      body = "This is a fancy test project for testing"
    }
  ]
}

module "team" {
  source      = "../../modules/team"
  name        = "test-team-1"
  description = "This team is created with terraform to test the terraformn-github-repository module."
  privacy     = "secret"
  members = [
    {
      username = "terraform-test-user-1"
      role     = "member"
    }
  ]
}
