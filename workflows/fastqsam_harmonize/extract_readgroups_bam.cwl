#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - $import: ../../tools/readgroup.yml
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement

inputs:
  - id: readgroups_bam_uuid
    type: ../../tools/readgroup.yml#readgroups_bam_uuid
  - id: bioclient_config
    type: File

outputs:
  - id: output
    type: ../../tools/readgroup.yml#readgroups_bam_file
    outputSource: emit_readgroups_bam_file/output

steps:
  - id: extract_bam
    run: ../../tools/bio_client_download.cwl
    in:
      - id: config-file
        source: bioclient_config
      - id: download_handle
        source: readgroups_bam_uuid
        valueFrom: $(self.bam_uuid)
      - id: file_size
        source: readgroups_bam_uuid
        valueFrom: $(self.bam_file_size)
    out:
      - id: output

  - id: emit_readgroups_bam_file
    run: ../../tools/emit_readgroups_bam_file.cwl
    in:
      - id: bam
        source: extract_bam/output
      - id: readgroup_meta_list
        source: readgroups_bam_uuid
        valueFrom: $(self.readgroup_meta_list)
    out:
      - id: output
