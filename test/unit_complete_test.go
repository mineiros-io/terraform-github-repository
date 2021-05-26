package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestUnitComplete(t *testing.T) {
	t.Parallel()

	expectedRepositoryNameA := fmt.Sprintf("test-unit-complete-A-%s", random.UniqueId())
	expectedRepositoryNameB := fmt.Sprintf("test-unit-complete-B-%s", random.UniqueId())

	expectedTeamName := fmt.Sprintf("test-unit-complete-%s", random.UniqueId())

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

	terraformOptions := &terraform.Options{
		TerraformDir: "unit-complete",
		Upgrade:      true,
		Vars: map[string]interface{}{
			"name":                          expectedRepositoryNameA,
			"repository_with_defaults_name": expectedRepositoryNameB,
			"issue_labels":                  issueLabels,

			"team_name": expectedTeamName,
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndPlan(t, terraformOptions)
	terraform.ApplyAndIdempotent(t, terraformOptions)
}
