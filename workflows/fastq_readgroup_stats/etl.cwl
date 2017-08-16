#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
 - class: InlineJavascriptRequirement
 - class: StepInputExpressionRequirement
 - class: SubworkflowFeatureRequirement

inputs:
  - id: gdc_token
    type: File
  - id: input_bam_gdc_id
    type: string
  - id: start_token
    type: File
  - id: thread_count
    type: int
  - id: run_uuid
    type: string

outputs:
  - id: token
    type: File
    outputSource: generate_token/token

steps:
  - id: extract_bam
    run: ../../tools/gdc_get_object.cwl
    in:
      - id: gdc_token
        source: gdc_token
      - id: gdc_uuid
        source: input_bam_gdc_id
    out:
      - id: output
 
  - id: transform
    run: transform.cwl
    in:
      - id: input_bam
        source: extract_bam/output
      - id: thread_count
        source: thread_count
      - id: run_uuid
        source: run_uuid
    out:
      - id: merge_all_sqlite_destination_sqlite

  - id: load_sqlite
    run: ../../tools/gdc_put_object.cwl
    in:
      - id: input
        source: transform/merge_all_sqlite_destination_sqlite
      - id: uuid
        source: run_uuid
    out:
      - id: output

  - id: generate_token
    run: ../../tools/generate_load_token.cwl
    in:
      - id: load1
        source: transform/merge_all_sqlite_destination_sqlite
    out:
      - id: token
