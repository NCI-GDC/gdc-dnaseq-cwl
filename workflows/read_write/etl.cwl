#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: MultipleInputFeatureRequirement
  - class: StepInputExpressionRequirement

inputs:
  - id: aws_config
    type: File
  - id: aws_shared_credentials
    type: File
  - id: bam_signpost_json
    type: File
  - id: endpoint_json
    type: File
  - id: load_bucket
    type: string
  - id: load_s3cfg_section
    type: string
  - id: uuid
    type: string

outputs: []

steps:
  - id: extract_bam
    run: ../../tools/aws_s3_get_signpost.cwl.yaml
    in:
      - id: aws_config
        source: aws_config
      - id: aws_shared_credentials
        source: aws_shared_credentials
      - id: signpost_json
        source: bam_signpost_json
      - id: endpoint_json
        source: endpoint_json
    out:
      - id: output

  - id: load_bam
    run: ../../tools/aws_s3_put.cwl.yaml
    in:
      - id: aws_config
        source: aws_config
      - id: aws_shared_credentials
        source: aws_shared_credentials
      - id: endpoint_json
        source: endpoint_json
      - id: input
        source: extract_bam/output
      - id: s3cfg_section
        source: load_s3cfg_section
      - id: s3uri
        source: load_bucket
        valueFrom: $(self + inputs.uuid + '/')
      - id: uuid
        source: uuid
        valueFrom: $(null)
    out:
      - id: output
