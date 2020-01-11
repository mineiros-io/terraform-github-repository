package test

import (
	"github.com/gruntwork-io/terratest/modules/terraform"
	"os"
	"testing"
)

var githubOrganization, githubToken string

func init() {
	githubOrganization = os.Getenv("GITHUB_ORGANIZATION")
	githubToken = os.Getenv("GITHUB_TOKEN")

	if githubOrganization == "" {
		panic("Please set a github organization using the GITHUB_ORGANIZATION environment variable.")
	}

	if githubToken == "" {
		panic("Please set a github token using the GITHUB_TOKEN environment variable.")
	}
}

func TestGithubPublicRepository(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		// The path to where your Terraform code is located
		TerraformDir: "../examples/public-repository",
		Upgrade:      true,
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)
}

func TestGithubPublicRepositoryWithCollaborators(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		// The path to where your Terraform code is located
		TerraformDir: "../examples/public-repository-with-collaborators",
		Upgrade:      true,
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)
}

func TestGithubPublicRepositoryCompleteExample(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		// The path to where your Terraform code is located
		TerraformDir: "../examples/public-repository-complete-example",
		Upgrade:      true,
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)
}
