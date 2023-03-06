REPO = gdc-dnaseq-cwl

.PHONY: build build-* init init-*
init: init-hooks

init-hooks:
	@echo
	@echo -- Installing Precommit Hooks --
	pre-commit install
