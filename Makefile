# Set default shell to bash
SHELL := /bin/bash

MOUNT_TARGET_DIRECTORY  = /app/src
BUILD_TOOLS_DOCKER_REPO = mineiros/build-tools

# Set default value for environment variable if there aren't set already
ifndef BUILD_TOOLS_VERSION
	BUILD_TOOLS_VERSION := latest
endif

ifndef BUILD_TOOLS_DOCKER_IMAGE
	BUILD_TOOLS_DOCKER_IMAGE := ${BUILD_TOOLS_DOCKER_REPO}:${BUILD_TOOLS_VERSION}
endif

GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
RESET  := $(shell tput -Txterm sgr0)

## Display help for all targets
help:
	@awk '/^[a-zA-Z_0-9%:\\\/-]+:/ { \
		msg = match(lastLine, /^## (.*)/); \
			if (msg) { \
				cmd = $$1; \
				msg = substr(lastLine, RSTART + 3, RLENGTH); \
				gsub("\\\\", "", cmd); \
				gsub(":+$$", "", cmd); \
				printf "  \x1b[32;01m%-35s\x1b[0m %s\n", cmd, msg; \
			} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST) | sort -u

.DEFAULT_GOAL := help

## Mounts the working directory inside a docker container and runs the pre-commit hooks
docker/pre-commit-hooks:
	@echo "${GREEN}Start running the pre-commit hooks with docker${RESET}"
	@docker run --rm \
		-v ${PWD}:${MOUNT_TARGET_DIRECTORY} \
		${BUILD_TOOLS_DOCKER_IMAGE} \
		sh -c "pre-commit run -a"

## Mounts the working directory inside a new container and runs the Go tests. Requires $GITHUB_TOKEN and $GITHUB_ORGANIZATION to be set
docker/unit-tests:
	@echo "${GREEN}Start running the unit tests with docker${RESET}"
	@docker run --rm \
		-e GITHUB_TOKEN \
		-e GITHUB_ORGANIZATION \
		-v ${PWD}:${MOUNT_TARGET_DIRECTORY} \
		${BUILD_TOOLS_DOCKER_IMAGE} \
		go test -v -timeout 10m -parallel 128 ./test

.PHONY: help docker/pre-commit-hooks docker/unit-tests
