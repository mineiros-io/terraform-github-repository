# Set default shell to bash
SHELL := /bin/bash -o pipefail

BUILD_TOOLS_VERSION      ?= v0.5.4
BUILD_TOOLS_DOCKER_REPO  ?= mineiros/build-tools
BUILD_TOOLS_DOCKER_IMAGE ?= ${BUILD_TOOLS_DOCKER_REPO}:${BUILD_TOOLS_VERSION}

#
# Some CI providers such as GitHub Actions, CircleCI, and TravisCI are setting
# the CI environment variable to a non-empty value by default to indicate that
# the current workflow is running in a Continuous Integration environment.
#
# If TF_IN_AUTOMATION is set to any non-empty value, Terraform adjusts its
# output to avoid suggesting specific commands to run next.
# https://www.terraform.io/docs/commands/environment-variables.html#tf_in_automation
#
# We are using GNU style quiet commands to disable set V to non-empty e.g. V=1
# https://www.gnu.org/software/automake/manual/html_node/Debugging-Make-Rules.html
#
ifdef CI
	TF_IN_AUTOMATION ?= 1
	export TF_IN_AUTOMATION

	V ?= 1
endif

ifndef NOCOLOR
	GREEN  := $(shell tput -Txterm setaf 2)
	YELLOW := $(shell tput -Txterm setaf 3)
	WHITE  := $(shell tput -Txterm setaf 7)
	RESET  := $(shell tput -Txterm sgr0)
endif

DOCKER_RUN_FLAGS += --rm
DOCKER_RUN_FLAGS += -v ${PWD}:/app/src
DOCKER_RUN_FLAGS += -e TF_IN_AUTOMATION
DOCKER_RUN_FLAGS += -e USER_UID=$(shell id -u)

DOCKER_GITHUB_FLAGS += -e GITHUB_TOKEN
DOCKER_GITHUB_FLAGS += -e GITHUB_ORGANIZATION

DOCKER_FLAGS   += ${DOCKER_RUN_FLAGS}
DOCKER_RUN_CMD  = docker run ${DOCKER_FLAGS} ${BUILD_TOOLS_DOCKER_IMAGE}

.PHONY: default
default: help

## Run pre-commit hooks in build-tools docker container.
.PHONY: test/pre-commit
test/pre-commit: DOCKER_FLAGS += ${DOCKER_GITHUB_FLAGS}
test/pre-commit:
	$(call docker-run,pre-commit run -a)

## Run all Go tests inside a build-tools docker container. This is complementary to running 'go test ./test/...'.
.PHONY: test/unit-tests
test/unit-tests: DOCKER_FLAGS += ${DOCKER_GITHUB_FLAGS}
test/unit-tests:
	@echo "${YELLOW}[TEST] ${GREEN}Start Running Go Tests in Docker Container.${RESET}"
	$(call go-test,./test/...)

## Clean up cache and temporary files
.PHONY: clean
clean:
	$(call rm-command,.terraform)
	$(call rm-command,*.tfplan)
	$(call rm-command,examples/*/.terraform)
	$(call rm-command,examples/*/*.tfplan)

## Display help for all targets
.PHONY: help
help:
	@awk '/^.PHONY: / { \
		msg = match(lastLine, /^## /); \
			if (msg) { \
				cmd = substr($$0, 9, 100); \
				msg = substr(lastLine, 4, 1000); \
				printf "  ${GREEN}%-30s${RESET} %s\n", cmd, msg; \
			} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)

# define helper functions
quiet-command = $(if ${V},${1},$(if ${2},@echo ${2} && ${1}, @${1}))
docker-run    = $(call quiet-command,${DOCKER_RUN_CMD} ${1} | cat,"${YELLOW}[DOCKER RUN] ${GREEN}${1}${RESET}")
go-test       = $(call quiet-command,${DOCKER_RUN_CMD} go test -v -count 1 -timeout 45m -parallel 128 ${1} | cat,"${YELLOW}[TEST] ${GREEN}${1}${RESET}")
rm-command    = $(call quiet-command,rm -rf ${1},"${YELLOW}[CLEAN] ${GREEN}${1}${RESET}")
