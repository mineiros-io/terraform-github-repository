package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/stretchr/testify/require"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestGithubPublicRepositoryWithWebhook(t *testing.T) {
	t.Parallel()

	const OutputRepositoryName = "repository_name"
	// const OutputRepositoryURL = "repository_url"
	const OutputWebhookContentType = "webhook_content_type"
	const OutputWebhookInsecureSsl = "webhook_insecure_ssl"
	const OutputWebhookSecret = "webhook_secret"
	const OutputWebhookActive = "webhook_active"
	const OutputWebhookEvents = "webhook_events"
	const OutputWebhookURL = "webhook_url"

	GithubOrganization := checkIfEnvironmentVariablesAreSet()

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

	// Validate the name of the created repository matches the on we passed in as a variable
	repositoryName := terraform.OutputRequired(t, terraformOptions, OutputRepositoryName)
	require.Equal(t, fmt.Sprintf("%s/%s", GithubOrganization, expectedRepositoryName),
		repositoryName, "Name of repository %q should match %q",
		fmt.Sprintf("%s/%s", GithubOrganization, expectedRepositoryName), repositoryName)

	// Validate the content-type of the created webhook matches the on we passed in as a variable
	webhookContentType := terraform.OutputRequired(t, terraformOptions, OutputWebhookContentType)
	require.Equal(t, expectedWebhookContentType,
		webhookContentType, "Webhook content-type %q should match %q",
		expectedWebhookContentType, webhookContentType)

	// Validate the insecure SSL setting of the created webhook matches the on we passed in as a variable
	webhookInsecureSsl := terraform.OutputRequired(t, terraformOptions, OutputWebhookInsecureSsl)
	require.Equal(t, expectedWebhookInsecureSsl,
		webhookInsecureSsl, "Webhook insecure SSL setting %q should match %q",
		expectedWebhookInsecureSsl, webhookInsecureSsl)

	// Validate the secret of the created webhook matches the on we passed in as a variable
	webhookSecret := terraform.OutputRequired(t, terraformOptions, OutputWebhookSecret)
	require.Equal(t, expectedWebhookSecret,
		webhookSecret, "Webhook secret %q should match %q",
		expectedWebhookSecret, webhookSecret)

	// Validate the active status of the created webhook matches the on we passed in as a variable
	webhookActive := terraform.OutputRequired(t, terraformOptions, OutputWebhookActive)
	require.Equal(t, expectedWebhookActive,
		webhookActive, "Webhook active status %q should match %q",
		expectedWebhookActive, webhookActive)

	// Validate the events that trigger the created webhook matches the on we passed in as a variable
	webhookEvents := terraform.OutputList(t, terraformOptions, OutputWebhookEvents)
	require.ElementsMatch(t, expectedWebHookEvents,
		webhookEvents, "Elements of webhook events %q should match elements of %q",
		expectedWebHookEvents, webhookEvents)

	// Validate the URL of the created webhook matches the on we passed in as a variable
	webhookURL := terraform.OutputRequired(t, terraformOptions, OutputWebhookURL)
	require.Equal(t, expectedWebhookURL,
		webhookURL, "Webhook URL %q should match %q",
		expectedWebhookURL, webhookURL)
}
