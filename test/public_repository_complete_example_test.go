package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

func TestGithubPublicRepositoryCompleteExample(t *testing.T) {
	t.Parallel()

	const OutputTeamName = "team_name"
	const OutputRepositoryDefaults = "repository_defaults"
	const OutputRepositoryName = "repository_name"
	const OutputRepositoryWithDefaultsName = "repository_with_defaults_name"

	githubOrganization := checkIfEnvironmentVariablesAreSet()

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
		TerraformDir: "../examples/public-repository-complete-example",
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

	// Retrieve all outputs from Terraform
	out := terraform.OutputAll(t, terraformOptions)

	// Validate that the name of the created team matches the one we defined as a variable
	teamName, ok := out[OutputTeamName].(string)
	require.True(t, ok, fmt.Sprintf(
		"Wrong data type for '%s', expected string, got %T",
		OutputTeamName,
		out[OutputTeamName]))

	require.Equal(t, expectedTeamName, teamName, "String %q should match %q",
		expectedTeamName, teamName)

	// Validate that the type of the outputs for the defaults is correct
	repositoryDefaults, ok := out[OutputRepositoryDefaults].(map[string]interface{})
	require.True(t, ok, fmt.Sprintf(
		"Wrong data type for '%s', expected map[string], got %T",
		OutputRepositoryDefaults,
		out[OutputRepositoryDefaults]))

	// Validate that the returned map of repository defaults
	require.Equal(t, expectedRepositoryDefaults, repositoryDefaults, "Map item %q should match %q",
		expectedRepositoryDefaults, repositoryDefaults)

	// Validate that the names of the created repositories match the ones we passed as variables
	repositoryNameA, ok := out[OutputRepositoryName].(string)
	require.True(t, ok, fmt.Sprintf("Wrong data type for '%s', expected string, got %T",
		OutputRepositoryName,
		out[OutputRepositoryName]))

	expectedFullRepositoryNameA := fmt.Sprintf("%s/%s", githubOrganization, expectedRepositoryNameA)
	require.Equal(t, expectedFullRepositoryNameA, repositoryNameA, "String %q should match %q",
		expectedFullRepositoryNameA, repositoryNameA)

	repositoryNameB, ok := out[OutputRepositoryWithDefaultsName].(string)
	require.True(t, ok, fmt.Sprintf(
		"Wrong data type for '%s', expected string, got %T",
		OutputRepositoryWithDefaultsName,
		out[OutputRepositoryWithDefaultsName]))

	expectedFullRepositoryNameB := fmt.Sprintf("%s/%s", githubOrganization, expectedRepositoryNameB)
	require.Equal(t, expectedFullRepositoryNameB, repositoryNameB, "String %q should match %q",
		expectedFullRepositoryNameB, repositoryNameB)
}
