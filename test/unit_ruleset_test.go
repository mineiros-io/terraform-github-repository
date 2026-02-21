package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestUnitRuleset(t *testing.T) {
	t.Parallel()

	repoName := fmt.Sprintf("test-unit-ruleset-%s", random.UniqueId())
	rulesetName := fmt.Sprintf("ruleset-%s", random.UniqueId())

	terraformOptions := &terraform.Options{
		TerraformDir: "unit-ruleset",
		Upgrade:      true,
		Vars: map[string]interface{}{
			"name":         repoName,
			"ruleset_name": rulesetName,
		},
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndPlan(t, terraformOptions)
	terraform.ApplyAndIdempotent(t, terraformOptions)

	rulesetIDs := terraform.OutputMap(t, terraformOptions, "ruleset_ids")
	if len(rulesetIDs) == 0 {
		t.Fatalf("expected at least one ruleset id for %s", repoName)
	}
}
