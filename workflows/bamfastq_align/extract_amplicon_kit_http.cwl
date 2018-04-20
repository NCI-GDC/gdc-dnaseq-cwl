#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: SchemaDefRequirement
    types:
      - $import: ../../tools/amplicon_kit.yml

inputs:
  - id: gdc_token
    type: File
  - id: amplicon_kit_set_uuid
    type: ../../tools/amplicon_kit.yml#amplicon_kit_set_uuid

outputs:
  - id: output
    type: ../../tools/amplicon_kit.yml#amplicon_kit_set_file
    outputSource: emit_amplicon_kit/output

steps:
  - id: extract_amplicon_kit_amplicon
    run: ../../tools/gdc_get_object.cwl
    in:
      - id: gdc_token
        source: gdc_token
      - id: gdc_uuid
        source: amplicon_kit_set_uuid
        valueFrom: $(self.amplicon_kit_amplicon_uuid)
      - id: file_size
        source: amplicon_kit_set_uuid
        valueFrom: $(self.amplicon_kit_amplicon_file_size)
    out:
      - id: output

  - id: extract_amplicon_kit_target
    run: ../../tools/gdc_get_object.cwl
    in:
      - id: gdc_token
        source: gdc_token
      - id: gdc_uuid
        source: amplicon_kit_set_uuid
        valueFrom: $(self.amplicon_kit_target_uuid)
      - id: file_size
        source: amplicon_kit_set_uuid
        valueFrom: $(self.amplicon_kit_target_file_size)
    out:
      - id: output

  - id: emit_amplicon_kit
    run: ../../tools/emit_amplicon_kit_file.cwl
    in:
      - id: amplicon_kit_amplicon_file
        source: extract_amplicon_kit_amplicon/output
      - id: amplicon_kit_target_file
        source: extract_amplicon_kit_target/output
    out:
      - id: output
