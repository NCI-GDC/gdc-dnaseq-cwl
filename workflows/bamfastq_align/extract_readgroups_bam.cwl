#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - $import: ../../tools/readgroup.yml
  - class: InlineJavascriptRequirement
  - class: ScatterFeatureRequirement
  - class: StepInputExpressionRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  - id: bioclient_config
    type: File
  - id: readgroups_bam_uuid
    type: ../../tools/readgroup.yml#readgroups_bam_uuid

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

  - id: list_readgroup_meta_list
    run: ../../tools/readgroup_meta_array_to_readgroup_meta_array.cwl
    in:
      - id: input
        source: readgroups_bam_uuid
        valueFrom: $(self.readgroup_meta_list)
    out:
      - id: output

  - id: extract_capture_kit
    run: extract_capture_kit.cwl
    scatter: readgroup_meta
    in:
      - id: bioclient_config
        source: bioclient_config
      - id: readgroup_meta
        source: list_readgroup_meta_list/output
    out:
      - id: output

  - id: emit_readgroups_bam_file
    run: ../../tools/emit_readgroups_bam_file.cwl
    in:
      - id: bam
        source: extract_bam/output
      - id: readgroup_meta_list
        source: extract_capture_kit/output
    out:
      - id: output
