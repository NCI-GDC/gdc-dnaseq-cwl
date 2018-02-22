#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - $import: ../../tools/readgroup.yml
  - class: InlineJavascriptRequirement
  - class: Scatter
  - class: StepInputExpressionRequirement

inputs:
  - id: bioclient_config
    type: File
  - id: readgroup_meta
    type: ../../tools/readgroup.yml#readgroup_meta

outputs:
  - id: output
    type: ../../tools/readgroup.yml#readgroup_meta
    outputSource: emit_readgroup_meta/output

steps:
  - id: extract_capture_kit_bait
    run: ../../tools/bio_client_download.cwl
    scatter: download_handle
    in:
      - id: config-file
        source: bioclient_config
      - id: download_handle
        source: readgroup_meta
        valueFrom: $(self.capture_kit_bait_uuid)
      - id: file_size
        valueFrom: 1
    out:
      - id: output

  - id: extract_capture_kit_target
    run: ../../tools/bio_client_download.cwl
    scatter: download_handle
    in:
      - id: config-file
        source: bioclient_config
      - id: download_handle
        source: readgroup_meta
        valueFrom: $(self.capture_kit_target_uuid)
      - id: file_size
        valueFrom: 1
    out:
      - id: output

  - id: emit_readgroup_meta
    run: ../../tools/emit_readgroup_meta_capture_kit_file.cwl
    in:
      - id: capture_kit_bait_file
        source: extract_capture_kit_bait/output
      - id: capture_kit_target_file
        source: extract_capture_kit_target/output
      - id: readgroup_meta
        source: readgroup_meta
    out:
      - id: output
