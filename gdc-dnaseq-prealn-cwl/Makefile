# quay repo not git repo
REPO = gdc-dnaseq-prealn-cwl
# TODO: Replace me
ENTRY_CWL = "gdc_dnaseq.aligned_reads.workflow.cwl"

VERSION := $(shell date -u +"%Y%m%dT%H%MZ")
COMMIT_HASH:=$(shell git rev-parse HEAD)

DOCKER_REPO := quay.io/ncigdc
DOCKER_IMAGE_COMMIT := ${DOCKER_REPO}/${REPO}:${COMMIT_HASH}
DOCKER_IMAGE := ${DOCKER_REPO}/${REPO}:${VERSION}

.PHONY: version version-* name
name:
	@echo ${WORKFLOW_NAME}

version:
	@echo --- VERSION: ${VERSION} ---

version-docker:
	@echo ${DOCKER_IMAGE_COMMIT}
	@echo ${DOCKER_IMAGE}

.PHONY: docker-*
docker-login:
	@echo
	docker login -u="${QUAY_USERNAME}" -p="${QUAY_PASSWORD}" quay.io


.PHONY: build build-* clean init init-* lint requirements run version
init: init-pip

init-pip:
	@echo
	@echo -- Installing pip packages --
	pip3 install --no-cache-dir cwltool==1.0.20180306163216

.PHONY: pack pack-%
pack:
	@python -m cwltool --pack "${ENTRY_CWL}"

run:
	@docker run --rm ${DOCKER_IMAGE_COMMIT} pack ENTRY_CWL=/opt/${ENTRY_CWL}

.PHONY: validate validate-*
validate:
	@python -m cwltool --validate "${ENTRY_CWL}"

validate-docker:
	@docker run --rm ${DOCKER_IMAGE_COMMIT} validate ENTRY_CWL=/opt/${ENTRY_CWL}

.PHONY: build build-*
build: build-docker

build-docker:
	@echo
	@echo -- Building docker --
	docker build .. \
		--file ./Dockerfile \
		--build-arg WORKFLOW=${WORKFLOW_NAME} \
		-t "${DOCKER_IMAGE_COMMIT}"


.PHONY: publish publish-release
publish:
	docker push ${DOCKER_IMAGE_COMMIT}

publish-staging: publish

publish-release: publish
	docker tag ${DOCKER_IMAGE_COMMIT} ${DOCKER_IMAGE}
	docker push ${DOCKER_IMAGE}