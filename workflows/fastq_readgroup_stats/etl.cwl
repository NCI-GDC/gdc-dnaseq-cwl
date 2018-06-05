#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
 - class: InlineJavascriptRequirement
 - class: StepInputExpressionRequirement
 - class: SubworkflowFeatureRequirement

inputs:
  - id: bioclient_config
    type: File
  - id: bioclient_load_bucket
    type: string
  - id: input_bam_gdc_id
    type: string
  - id: input_bam_file_size
    type: long
  - id: start_token
    type: File
  - id: thread_count
    type: long
  - id: job_uuid
    type: string

outputs:
  - id: indexd_sqlite_uuid
    type: string
    outputSource: emit_sqlite_uuid/output

steps:
  - id: extract_bam
    run: ../../tools/bio_client_download.cwl
    in:
      - id: config-file
        source: bioclient_config
      - id: download_handle
        source: input_bam_gdc_id
      - id: file_size
        source: input_bam_file_size
    out:
      - id: output
 
  - id: transform
    run: transform.cwl
    in:
      - id: input_bam
        source: extract_bam/output
      - id: thread_count
        source: thread_count
      - id: job_uuid
        source: job_uuid
    out:
      - id: sqlite

  - id: load_sqlite
    run: ../../tools/bio_client_upload_pull_uuid.cwl
    in:
      - id: config-file
        source: bioclient_config
      - id: input
        source: transform/sqlite
      - id: upload-bucket
        source: bioclient_load_bucket
      - id: upload-key
        valueFrom: $(inputs.job_uuid)/$(inputs.input.basename)
      - id: job_uuid
        source: job_uuid
        valueFrom: $(null)
    out:
      - id: output

  - id: emit_sqlite_uuid
    run: ../../tools/emit_json_value.cwl
    in:
      - id: input
        source: load_sqlite/output
      - id: key
        valueFrom: did
    out:
      - id: output
