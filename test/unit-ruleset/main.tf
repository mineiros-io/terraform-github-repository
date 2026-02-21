# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CREATE A REPOSITORY WITH A SIMPLE RULESET FOR TESTING
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

module "repository" {
  source = "../.."

  name = var.name
  rulesets = [
    {
      name        = var.ruleset_name
      target      = "branch"
      enforcement = "active"

      conditions = {
        ref_name = {
          include = ["~DEFAULT_BRANCH"]
          exclude = ["refs/heads/ignore-*"]
        }
      }

      rules = {
        required_linear_history = true
        required_signatures     = true
        required_status_checks = {
          strict_required_status_checks_policy = true
          required_check = [
            {
              context = var.status_check_context
            }
          ]
        }
      }
    },
    {
      name        = "${var.ruleset_name}-push"
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

output "ruleset_ids" {
  value = module.repository.ruleset_ids
}
