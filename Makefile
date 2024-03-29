.DEFAULT_GOAL: help
SHELL := /bin/bash

PROJECTNAME := "fip-commons"

.PHONY: help
all: help
help: Makefile
	@echo
	@echo " Choose a command to run in "$(PROJECTNAME)":"
	@echo
	@sed -n 's/^##//p' $< | column -t -s ':' |  sed -e 's/^/ /'
	@echo

check-variable-%: # detection of undefined variables.
	@[[ "${${*}}" ]] || (echo '*** Please define variable `${*}` ***' && exit 1)

optional-variable-%: # detection of undefined variables.
	@[[ "${${*}}" ]] || (echo '*** Variable `${*}` is optional. Make sure you understand how to use it ***')

check-%: # detection of required software.
	@which ${*} > /dev/null || (echo '*** Please install `${*}` ***' && exit 1)

## init: Init the project. GITHUB_PROJECT=demo make init
init: check-variable-GITHUB_PROJECT
	@test -f ./scripts/init.sh && ./scripts/init.sh ${GITHUB_PROJECT} || echo "Project already initialized with name ${GITHUB_PROJECT}"

## drone-init: Init the drone-project. GITHUB_PROJECT=demo GITHUB_TOKEN=123token321 DRONE_TOKEN=tokenhere REGISTRY=registry.sighup.io REGISTRY_USER=robotuser REGISTRY_PASSWORD=thepassword make drone-init
drone-init: check-variable-GITHUB_PROJECT check-variable-GITHUB_TOKEN check-variable-DRONE_TOKEN check-variable-REGISTRY check-variable-REGISTRY_USER check-variable-REGISTRY_PASSWORD
	@test -f ./scripts/drone-init.sh && ./scripts/drone-init.sh ${GITHUB_PROJECT} ${GITHUB_TOKEN} ${DRONE_TOKEN} ${REGISTRY} ${REGISTRY_USER} ${REGISTRY_PASSWORD} || echo "Drone project already initialized with name ${GITHUB_PROJECT}"

## lint: Run the policeman over the repository
lint: check-docker
	@docker build --no-cache --pull --target linter -f build/builder/Dockerfile -t ${PROJECTNAME}:local-lint .

## test: Run unit testing
test: check-docker
	@docker build --no-cache --pull --target tester -f build/builder/Dockerfile -t ${PROJECTNAME}:local-test .

## license: Check license headers are in-place in all files in the project
license: check-docker
	@docker build --no-cache --pull --target license -f build/builder/Dockerfile -t ${PROJECTNAME}:local-license .

## clean-%: Clean the container image resulting from another target. make build clean-build
clean-%:
	@docker rmi -f ${PROJECTNAME}:local-${*}
