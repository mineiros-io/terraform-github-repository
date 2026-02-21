# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CREATE A REPOSITORY WITH A RULESET
#   - create a private repository
#   - attach a ruleset that enforces signed commits and one status check on the default branch
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

module "repository" {
  source = "mineiros-io/repository/github"

  name       = "example-with-ruleset"
  visibility = "private"

  rulesets = [
    {
      name        = "default-branch-protection"
      target      = "branch"
      enforcement = "active"

      conditions = {
        ref_name = {
          include = ["~DEFAULT_BRANCH"]
          exclude = []
        }
      }

      rules = {
        required_linear_history = true
        required_signatures     = true
        required_status_checks = {
          strict_required_status_checks_policy = true
          required_check = [
            {
              context = "ci/test"
            }
          ]
        }
      }
    },
    {
      name        = "push-restrictions"
      target      = "push"
      enforcement = "active"

      rules = {
        creation         = true
        deletion         = true
        non_fast_forward = true

        file_path_restriction = {
          restricted_file_paths = ["/secrets/**"]
        }

        max_file_size = {
          max_file_size = 10485760
        }
      }
    }
  ]
}
