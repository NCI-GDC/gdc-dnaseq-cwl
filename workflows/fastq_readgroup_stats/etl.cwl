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
    type: long
  - id: run_uuid
    type: string

  - id: aws_config
    type: File
  - id: aws_shared_credentials
    type: File
  - id: endpoint_json
    type: File
  - id: load_bucket
    type: string
  - id: s3cfg_section
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
    run: ../../tools/aws_s3_put.cwl
    in:
      - id: aws_config
        source: aws_config
      - id: aws_shared_credentials
        source: aws_shared_credentials
      - id: endpoint_json
        source: endpoint_json
      - id: input
        source: transform/merge_all_sqlite_destination_sqlite
      - id: s3cfg_section
        source: s3cfg_section
      - id: s3_uri
        source: load_bucket
        valueFrom: $(self + "/" inputs.run_uuid + "/")
      - id: run_uuid
        source: run_uuid
        valueFrom: $(null)
    out:
      - id: output

  - id: generate_token
    run: ../../tools/generate_load_token.cwl
    in:
      - id: load1
        source: transform/merge_all_sqlite_destination_sqlite
    out:
      - id: token
