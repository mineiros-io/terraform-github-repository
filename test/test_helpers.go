package test

import "os"

func checkIfEnvironmentVariablesAreSet() string {
	githubOrganization := os.Getenv("GITHUB_ORGANIZATION")
	githubToken := os.Getenv("GITHUB_TOKEN")

	if githubOrganization == "" {
		panic("Please set a github organization using the GITHUB_ORGANIZATION environment variable.")
	}

	if githubToken == "" {
		panic("Please set a github token using the GITHUB_TOKEN environment variable.")
	}

	return githubOrganization
}
