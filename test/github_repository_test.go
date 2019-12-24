package test

import (
	"github.com/gruntwork-io/terratest/modules/terraform"
	"os"
	"testing"
)

func TestTerraformRepository(t *testing.T) {
	t.Parallel()

	githubOrganization := os.Getenv("GITHUB_ORGANIZATION")
	githubToken := os.Getenv("GITHUB_TOKEN")

	if githubToken == "" {
		panic("Please set a github token using the GITHUB_TOKEN environment variable.")
	}

	terraformOptions := &terraform.Options{
		// The path to where your Terraform code is located
		TerraformDir: "../examples/public-repository",
		Upgrade:      true,
		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"github_token":        githubToken,
			"github_organization": githubOrganization,
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)
}

func TestTerraformRepositoryWithCollaborators(t *testing.T) {
	t.Parallel()

	githubOrganization := os.Getenv("GITHUB_ORGANIZATION")
	githubToken := os.Getenv("GITHUB_TOKEN")

	if githubToken == "" {
		panic("Please set a github token using the GITHUB_TOKEN environment variable.")
	}

	terraformOptions := &terraform.Options{
		// The path to where your Terraform code is located
		TerraformDir: "../examples/public-repository-with-collaborators",
		Upgrade:      true,
		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"github_token":        githubToken,
			"github_organization": githubOrganization,
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)
}
