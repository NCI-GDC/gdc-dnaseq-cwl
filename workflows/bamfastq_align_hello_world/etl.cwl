#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement

inputs:
  - id: bioclient_config
    type: File
  - id: bioclient_load_bucket
    type: string
  - id: job_uuid
    type: string
  - id: reference_fai_gdc_id
    type: string
  - id: reference_fai_file_size
    type: long

outputs:
  - id: indexd_bam_uuid
    type: string
    outputSource: emit_bam_uuid/output
  - id: indexd_bai_uuid
    type: string
    outputSource: emit_bam_uuid/output
  - id: indexd_sqlite_uuid
    type: string
    outputSource: emit_bam_uuid/output

steps:
  - id: extract_reference_fai
    run: ../../tools/bio_client_download.cwl
    in:
      - id: config-file
        source: bioclient_config
      - id: download_handle
        source: reference_fai_gdc_id
      - id: file_size
        source: reference_fai_file_size
    out:
      - id: output
 
  - id: hello_world
    run: hello_world.cwl
    in:
      - id: INPUT
        source: job_uuid
    out:
      - id: OUTPUT

  - id: load_bam
    run: ../../tools/bio_client_upload_pull_uuid.cwl
    in:
      - id: config-file
        source: bioclient_config
      - id: input
        source: hello_world/OUTPUT
      - id: upload-bucket
        source: bioclient_load_bucket
      - id: upload-key
        valueFrom: $(inputs.job_uuid)/$(inputs.input.basename)
      - id: job_uuid
        source: job_uuid
        valueFrom: $(null)
    out:
      - id: output

  - id: emit_bam_uuid
    run: ../../tools/emit_json_value.cwl
    in:
      - id: input
        source: load_bam/output
      - id: key
        valueFrom: did
    out:
      - id: output

