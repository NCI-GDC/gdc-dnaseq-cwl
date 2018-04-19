#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: SchemaDefRequirement
    types:
      - $import: ../../tools/capture_kit.yml

inputs:
  - id: gdc_token
    type: File
  - id: capture_kit_set_uuid
    type: ../../tools/capture_kit.yml#capture_kit_set_uuid

outputs:
  - id: output
    type: ../../tools/capture_kit.yml#capture_kit_set_file
    outputSource: emit_capture_kit/output

steps:
  - id: extract_capture_kit_bait
    run: ../../tools/gdc_get_object.cwl
    in:
      - id: gdc_token
        source: gdc_token
      - id: gdc_uuid
        source: capture_kit_set_uuid
        valueFrom: $(self.capture_kit_bait_uuid)
      - id: file_size
        source: capture_kit_set_uuid
        valueFrom: $(self.capture_kit_bait_file_size)
    out:
      - id: output

  - id: extract_capture_kit_target
    run: ../../tools/gdc_get_object.cwl
    in:
      - id: gdc_token
        source: gdc_token
      - id: gdc_uuid
        source: capture_kit_set_uuid
        valueFrom: $(self.capture_kit_target_uuid)
      - id: file_size
        source: capture_kit_set_uuid
        valueFrom: $(self.capture_kit_target_file_size)
    out:
      - id: output

  - id: emit_capture_kit
    run: ../../tools/emit_capture_kit_file.cwl
    in:
      - id: capture_kit_bait_file
        source: extract_capture_kit_bait/output
      - id: capture_kit_target_file
        source: extract_capture_kit_target/output
    out:
      - id: output
