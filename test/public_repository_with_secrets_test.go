package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestGithubPublicRepositoryWithSecret(t *testing.T) {
	t.Parallel()

	// Set the name for the repository this test should create
	expectedRepositoryName := fmt.Sprintf("test-public-repository-with-secret-%s", random.UniqueId())

	// Set config settings for the secret this test should create
	expectedSecretName := "MYSECRET"
	expectedSecretValue := "42"

	terraformOptions := &terraform.Options{
		// The path to where your Terraform code is located
		TerraformDir: "public-repository-with-secret",
		Upgrade:      true,
		Vars: map[string]interface{}{
			"name":        expectedRepositoryName,
			"secret_name": expectedSecretName,
			"secret_text": expectedSecretValue,
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

}
