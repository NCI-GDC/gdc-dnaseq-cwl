# Makefile to manage an individual CWL Docker image

WORKFLOW_NAME = gdc_dnaseq_cwl
ENTRY_CWL = "gdc_dnaseq.bamfastq_align.workflow.cwl"

.PHONY: pack pack-%
pack:
	@python -m cwltool --pack "${ENTRY_CWL}"

.PHONY: validate validate-*
validate:
	@python -m cwltool --validate "${ENTRY_CWL}"
