package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestGithubPublicRepositoryWithCollaborators(t *testing.T) {
	t.Parallel()

	expectedRepositoryName := fmt.Sprintf("test-public-repository-with-collaborators-%s", random.UniqueId())

	terraformOptions := &terraform.Options{
		// The path to where your Terraform code is located
		TerraformDir: "public-repository-with-collaborators",
		Upgrade:      true,
		Vars: map[string]interface{}{
			"name": expectedRepositoryName,
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)
}
