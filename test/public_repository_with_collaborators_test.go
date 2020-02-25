package test

import (
	"crypto/tls"
	"fmt"
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/stretchr/testify/require"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestGithubPublicRepositoryWithCollaborators(t *testing.T) {
	t.Parallel()

	const OutputRepositoryName = "repository_name"
	const OutputRepositoryURL = "repository_url"

	GithubOrganization := checkIfEnvironmentVariablesAreSet()

	expectedRepositoryName := fmt.Sprintf("test-public-repository-with-collaborators-%s", random.UniqueId())

	terraformOptions := &terraform.Options{
		// The path to where your Terraform code is located
		TerraformDir: "../examples/public-repository-with-collaborators",
		Upgrade:      true,
		Vars: map[string]interface{}{
			"name": expectedRepositoryName,
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	repositoryName := terraform.OutputRequired(t, terraformOptions, OutputRepositoryName)
	require.Equal(t, fmt.Sprintf("%s/%s", GithubOrganization, expectedRepositoryName),
		repositoryName, "Name of repository %q should match %q",
		fmt.Sprintf("%s/%s", GithubOrganization, expectedRepositoryName), repositoryName)

	// Retrieve the repository URL from the outputs
	repositoryURL := terraform.OutputRequired(t, terraformOptions, OutputRepositoryURL)

	// Check if the created repository is available through HTTP
	status := 200
	retries := 15
	sleep := 5 * time.Second
	tlsConfig := tls.Config{}
	http_helper.HttpGetWithRetryWithCustomValidation(
		t,
		repositoryURL,
		&tlsConfig,
		retries,
		sleep,
		func(statusCode int, body string) bool {
			return statusCode == status
		})
}
