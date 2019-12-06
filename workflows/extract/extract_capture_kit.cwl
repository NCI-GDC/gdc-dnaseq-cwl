#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: SchemaDefRequirement
    types:
      - $import: ../../tools/target_kit_schema.yml

inputs:
  bioclient_config: File
  capture_kit_set_uuid:
    type: ../../tools/target_kit_schema.yml#capture_kit_set_uuid

outputs:
  output:
    type: ../../tools/target_kit_schema.yml#capture_kit_set_file
    outputSource: emit_capture_kit/output

steps:
  extract_capture_kit_bait:
    run: ../../tools/bio_client_download.cwl
    in:
      config-file: bioclient_config
      download_handle:
        source: capture_kit_set_uuid
        valueFrom: $(self.capture_kit_bait_uuid)
    out: [ output ]

  extract_capture_kit_target:
    run: ../../tools/bio_client_download.cwl
    in:
      config-file: bioclient_config
      download_handle:
        source: capture_kit_set_uuid
        valueFrom: $(self.capture_kit_target_uuid)
    out: [ output ]

  emit_capture_kit:
    run: ../../tools/emit_capture_kit_file.cwl
    in:
      capture_kit_bait_file: extract_capture_kit_bait/output
      capture_kit_target_file: extract_capture_kit_target/output
    out: [ output ]
