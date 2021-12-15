[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>][homepage]

[![license][badge-license]][apache20]
[![Terraform Version][badge-terraform]][releases-terraform]
[![Join Slack][badge-slack]][slack]

# Tests

This directory contains a number of automated tests that cover the functionality
of the modules that ship with this repository.

## Introduction

We are using [Terratest] for automated tests that are located in the
[`test/` directory][testdirectory]. Terratest deploys _real_ infrastructure
(e.g., servers) in a _real_ environment (e.g., AWS).

The basic usage pattern for writing automated tests with Terratest is to:

1. Write tests using Go's built-in [package testing]: you create a file ending
   in `_test.go` and run tests with the `go test` command.
2. Use Terratest to execute your _real_ IaC tools (e.g., Terraform, Packer, etc.)
   to deploy _real_ infrastructure (e.g., servers) in a _real_ environment (e.g., AWS).
3. Validate that the infrastructure works correctly in that environment by
   making HTTP requests, API calls, SSH connections, etc.
4. Undeploy everything at the end of the test.

**Note #1**: Many of these tests create real resources in an AWS account.
That means they cost money to run, especially if you don't clean up after
yourself. Please be considerate of the resources you create and take extra care
to clean everything up when you're done!

**Note #2**: Never hit `CTRL + C` or cancel a build once tests are running or
the cleanup tasks won't run!

**Note #3**: We set `-timeout 45m` on all tests not because they necessarily
take 45 minutes, but because Go has a default test timeout of 10 minutes, after
which it does a `SIGQUIT`, preventing the tests from properly cleaning up after
themselves. Therefore, we set a timeout of 45 minutes to make sure all tests
have enough time to finish and cleanup.

## How to run the tests

This repository comes with a [Makefile], that helps you to run the
tests in a convenient way.
Alternatively, you can also run the tests without Docker.

### Run the tests with Docker

1. Install [Docker]
2. Set your AWS credentials as environment variables: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`
3. Run `make docker-run-tests`

### Run the tests without Docker

1. Install the latest version of [Go].
2. Install [Terraform].
3. Set your AWS credentials as environment variables: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`
4. Install go dependencies: `go mod download`
5. Run all tests: `go test -v -count 1 -timeout 45m -parallel 128 ./test/...`
6. Run a specific test: `go test -count 1 -v -timeout 45m -parallel 128 test/example_test.go`

<!-- References -->

[makefile]: https://github.com/mineiros-io/terraform-github-repository/blob/main/Makefile
[testdirectory]: https://github.com/mineiros-io/terraform-github-repository/tree/main/test
[homepage]: https://mineiros.io/?ref=terraform-github-repository
[terratest]: https://github.com/gruntwork-io/terratest
[package testing]: https://golang.org/pkg/testing/
[docker]: https://docs.docker.com/get-started/
[go]: https://golang.org/
[terraform]: https://www.terraform.io/downloads.html
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[badge-terraform]: https://img.shields.io/badge/terraform-1.x-623CE4.svg?logo=terraform
[badge-slack]: https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack
[releases-terraform]: https://github.com/hashicorp/terraform/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg
