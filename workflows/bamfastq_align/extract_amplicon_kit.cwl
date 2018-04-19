#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: SchemaDefRequirement
    types:
      - $import: ../../tools/capture_kit.yml

inputs:
  - id: bioclient_config
    type: File
  - id: amplicon_kit_set_uuid
    type: ../../tools/amplicon_kit.yml#amplicon_kit_set_uuid

outputs:
  - id: output
    type: ../../tools/amplicon_kit.yml#amplicon_kit_set_file
    outputSource: emit_amplicon_kit/output

steps:
  - id: extract_amplicon_kit_amplicon
    run: ../../tools/bio_client_download.cwl
    in:
      - id: config-file
        source: bioclient_config
      - id: download_handle
        source: amplicon_kit_set_uuid
        valueFrom: $(self.amplicon_kit_amplicon_uuid)
    out:
      - id: output

  - id: extract_amplicon_kit_target
    run: ../../tools/bio_client_download.cwl
    in:
      - id: config-file
        source: bioclient_config
      - id: download_handle
        source: amplicon_kit_set_uuid
        valueFrom: $(self.amplicon_kit_target_uuid)
    out:
      - id: output

  - id: emit_capture_kit
    run: ../../tools/emit_amplicon_kit_file.cwl
    in:
      - id: amplicon_kit_bait_file
        source: extract_amplicon_kit_amplicon/output
      - id: amplicon_kit_target_file
        source: extract_amplicon_kit_target/output
    out:
      - id: output
