package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestGithubPublicRepositoryCompleteExample(t *testing.T) {
	t.Parallel()

	// Set the names for the repositories this test should create
	expectedRepositoryNameA := fmt.Sprintf("test-public-repository-complete-example-A-%s", random.UniqueId())
	expectedRepositoryNameB := fmt.Sprintf("test-public-repository-complete-example-B-%s", random.UniqueId())

	expectedTeamName := fmt.Sprintf("test-public-repository-complete-example-%s", random.UniqueId())

	// We pass this map of default repository settings as a variable to Terraform
	expectedRepositoryDefaults := map[string]interface{}{
		"homepage_url":       "https://github.com/mineiros-io",
		"private":            "false",
		"allow_merge_commit": "true",
		"gitignore_template": "Terraform",
		"license_template":   "mit",
		"topics":             []interface{}{"terraform", "integration-test"},
	}

	// Define some issue labels we pass as variables to Terraform
	issueLabelNameA := random.UniqueId()
	issueLabelNameB := random.UniqueId()

	issueLabels := []interface{}{
		map[string]interface{}{
			"name":        issueLabelNameA,
			"description": "Work in Progress...",
			"color":       "d6c860",
		},
		map[string]interface{}{
			"name":        issueLabelNameB,
			"description": "This is a label created by Terraform...",
			"color":       "1dc34f",
		},
	}

	// Set Terraform options
	terraformOptions := &terraform.Options{
		// The path to where your Terraform code is located
		TerraformDir: "public-repository-complete-example",
		Upgrade:      true,
		Vars: map[string]interface{}{
			// Repositories
			"name":                          expectedRepositoryNameA,
			"repository_with_defaults_name": expectedRepositoryNameB,
			"issue_labels":                  issueLabels,
			"repository_defaults":           expectedRepositoryDefaults,

			//Team
			"team_name": expectedTeamName,
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)
}
