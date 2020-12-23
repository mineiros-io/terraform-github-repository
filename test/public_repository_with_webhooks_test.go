package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestGithubPublicRepositoryWithWebhook(t *testing.T) {
	t.Parallel()

	// Set the name for the repository this test should create
	expectedRepositoryName := fmt.Sprintf("test-public-repository-with-webhook-%s", random.UniqueId())

	// Set config settings for the webhook this test should create
	expectedWebhookURL := "https://test.example.com/test/events"
	expectedWebhookContentType := "application/json"
	expectedWebhookInsecureSsl := "false"
	expectedWebhookSecret := "foobar 31337 baz 42"
	expectedWebhookActive := "false"
	expectedWebHookEvents := []string{"issue_comment", "pull_request"}

	terraformOptions := &terraform.Options{
		// The path to where your Terraform code is located
		TerraformDir: "public-repository-with-webhook",
		Upgrade:      true,
		Vars: map[string]interface{}{
			"name":                 expectedRepositoryName,
			"webhook_content_type": expectedWebhookContentType,
			"webhook_insecure_ssl": expectedWebhookInsecureSsl,
			"webhook_secret":       expectedWebhookSecret,
			"webhook_active":       expectedWebhookActive,
			"webhook_events":       expectedWebHookEvents,
			"webhook_url":          expectedWebhookURL,
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

}
