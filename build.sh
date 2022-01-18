#!/bin/bash

set -eo pipefail

function build {
	make -C "$1" docker-login build-docker WORKFLOW_NAME="$1"
}

function publish-staging {
	make -C "$1" docker-login publish-staging
}

function publish-release {
	make -C "$1" docker-login publish-release
}

function validate {
	make --quiet -C "$1" validate-docker
}

case "$1" in
	build)
		for workflow in *; do
			if [ -f "${workflow}/Makefile" ]; then
				echo "Building $workflow"
				build "$workflow"
			fi
		done
	;;
	publish-staging)
		for workflow in *; do
			if [ -f "${workflow}/Makefile" ]; then
				echo "Publishing staging: $workflow"
				publish-staging "$workflow"
			fi
		done
	;;
	publish-release)
		for workflow in *; do
			if [ -f "${workflow}/Makefile" ]; then
				echo "Publishing release: $workflow"
				publish-release "$workflow"
			fi
		done
	;;
	validate)
		for workflow in *; do
			if [ -f "${workflow}/Makefile" ]; then
				echo "Validating docker: $workflow"
				validate "$workflow"
			fi
		done
	;;
esac