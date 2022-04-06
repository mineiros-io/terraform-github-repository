# Set default shell to bash
SHELL := /bin/bash -o pipefail

BUILD_TOOLS_VERSION      ?= v0.15.1
BUILD_TOOLS_DOCKER_REPO  ?= mineiros/build-tools
BUILD_TOOLS_DOCKER_IMAGE ?= ${BUILD_TOOLS_DOCKER_REPO}:${BUILD_TOOLS_VERSION}

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
  TF_IN_AUTOMATION ?= yes
  export TF_IN_AUTOMATION

  V ?= 1
endif

ifndef NOCOLOR
  GREEN  := $(shell tput -Txterm setaf 2)
  YELLOW := $(shell tput -Txterm setaf 3)
  WHITE  := $(shell tput -Txterm setaf 7)
  RESET  := $(shell tput -Txterm sgr0)
endif

GIT_TOPLEVEl = $(shell git rev-parse --show-toplevel)

# Generic docker run flags
DOCKER_RUN_FLAGS += -v ${GIT_TOPLEVEl}:/build
DOCKER_RUN_FLAGS += --rm
DOCKER_RUN_FLAGS += -e TF_IN_AUTOMATION
# If TF_VERSION is defined, TFSwitch will switch to the desired version on
# container startup. If TF_VERSION is omitted, the default version installed
# inside the docker image will be used.
DOCKER_RUN_FLAGS += -e TF_VERSION

# If SSH_AUTH_SOCK is set, we forward the SSH agent of the host system into
# the docker container. This is useful when working with private repositories
# and dependencies that might need to be cloned inside the container (e.g.
# private Terraform modules).
ifdef SSH_AUTH_SOCK
  DOCKER_SSH_FLAGS += -e SSH_AUTH_SOCK=/ssh-agent
  DOCKER_SSH_FLAGS += -v ${SSH_AUTH_SOCK}:/ssh-agent
endif

# If AWS_ACCESS_KEY_ID is defined, we are likely running inside an AWS provider
# module. To enable AWS authentication inside the docker container, we inject
# the relevant environment variables.
ifdef AWS_ACCESS_KEY_ID
  DOCKER_AWS_FLAGS += -e AWS_ACCESS_KEY_ID
  DOCKER_AWS_FLAGS += -e AWS_SECRET_ACCESS_KEY
  DOCKER_AWS_FLAGS += -e AWS_SESSION_TOKEN
endif

# If GOOGLE_CREDENTIALS is defined, we are likely running inside a GCP provider
# module. To enable GCP authentication inside the docker container, we inject
# the relevant environment variables (service-account key file).
ifdef GOOGLE_CREDENTIALS
	DOCKER_GCP_FLAGS += -e GOOGLE_CREDENTIALS
endif

# If GITHUB_OWNER is defined, we are likely running inside a GitHub provider
# module. To enable GitHub authentication inside the docker container,
# we inject the relevant environment variables.
ifdef GITHUB_OWNER
  DOCKER_GITHUB_FLAGS += -e GITHUB_TOKEN
  DOCKER_GITHUB_FLAGS += -e GITHUB_OWNER
endif

.PHONY: default
default: help

# Not exposed as a callable target by `make help`, since this is a one-time shot to simplify the development of this module.
.PHONY: template/adjust
template/adjust: FILTER = -path ./.git -prune -a -type f -o -type f -not -name Makefile
template/adjust:
	@find . $(FILTER) -exec sed -i -e "s,terraform-module-template,$${PWD##*/},g" {} \;

## Run pre-commit hooks inside a build-tools docker container.
.PHONY: test/pre-commit
test/pre-commit: DOCKER_FLAGS += ${DOCKER_SSH_FLAGS}
test/pre-commit:
	$(call docker-run,pre-commit run -a)

## Run all Go tests inside a build-tools docker container. This is complementary to running 'go test ./test/...'.
.PHONY: test/unit-tests
test/unit-tests: DOCKER_FLAGS += ${DOCKER_SSH_FLAGS}
test/unit-tests: DOCKER_FLAGS += ${DOCKER_GITHUB_FLAGS}
test/unit-tests: DOCKER_FLAGS += ${DOCKER_AWS_FLAGS}
test/unit-tests: DOCKER_FLAGS += ${DOCKER_GCP_FLAGS}
test/unit-tests: DOCKER_FLAGS += $(shell env | grep ^TF_VAR_ | cut -d = -f 1 | xargs -i printf ' -e {}')
test/unit-tests: DOCKER_FLAGS += -e TF_DATA_DIR=.terratest
test/unit-tests: TEST ?= "TestUnit"
test/unit-tests:
	@echo "${YELLOW}[TEST] ${GREEN}Start Running Go Tests in Docker Container.${RESET}"
	$(call go-test,./test -run $(TEST))

## Generate README.md with Terradoc
.PHONY: terradoc
terradoc:
	$(call quiet-command,terradoc generate -o README.md README.tfdoc.hcl)

## Clean up cache and temporary files
.PHONY: clean
clean:
	$(call rm-command,.terraform)
	$(call rm-command,.terraform.lock.hcl)
	$(call rm-command,*.tfplan)
	$(call rm-command,*/*/.terraform)
	$(call rm-command,*/*/*.tfplan)
	$(call rm-command,*/*/.terraform.lock.hcl)

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

# Define helper functions
DOCKER_FLAGS   += ${DOCKER_RUN_FLAGS}
DOCKER_RUN_CMD  = docker run ${DOCKER_FLAGS} ${BUILD_TOOLS_DOCKER_IMAGE}

quiet-command = $(if ${V},${1},$(if ${2},@echo ${2} && ${1}, @${1}))
docker-run    = $(call quiet-command,${DOCKER_RUN_CMD} ${1} | cat,"${YELLOW}[DOCKER RUN] ${GREEN}${1}${RESET}")
go-test       = $(call quiet-command,${DOCKER_RUN_CMD} go test -v -count 1 -timeout 45m -parallel 128 ${1} | cat,"${YELLOW}[TEST] ${GREEN}${1}${RESET}")
rm-command    = $(call quiet-command,rm -rf ${1},"${YELLOW}[CLEAN] ${GREEN}${1}${RESET}")
