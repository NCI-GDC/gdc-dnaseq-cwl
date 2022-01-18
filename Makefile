REPO = gdc-dnaseq-cwl

.PHONY: build build-* init init-*
init: init-hooks init-secrets

init-hooks:
	@echo
	@echo -- Installing Precommit Hooks --
	pre-commit install

init-secrets:
	@echo
	detect-secrets scan --update .secrets.baseline
	detect-secrets audit .secrets.baseline

.PHONY: build
build:
	@echo
	@echo -- Building dockers --
	@bash build.sh build


.PHONY: publish-staging publish-release
publish-staging:
	@echo
	@bash build.sh publish-staging

publish-release:
	@echo
	@bash build.sh publish-release

.PHONY: validate
validate:
	@bash build.sh validate