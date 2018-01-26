#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
 - class: InlineJavascriptRequirement
 - class: StepInputExpressionRequirement
 - class: SubworkflowFeatureRequirement

inputs:
  - id: bam_name
    type: string
  - id: bioclient_config
    type: File
  - id: bioclient_load_bucket
    type: string
  - id: fastq_1_gdc_id
    type:
      type: array
      items: string
  - id: fastq_1_file_size
    type:
      type: array
      items: long
  - id: fastq_2_gdc_id
    type:
      type: array
      items: string
  - id: fastq_2_file_size
    type:
      type: array
      items: long
  - id: fastq_s_gdc_id
    type:
      type: array
      items: string
  - id: fastq_s_file_size
    type:
      type: array
      items: long
  - id: start_token
    type: File

outputs:
  - id: indexd_bam_json
    type: File
    outputSource: load_bam/output
  - id: token
    type: File
    outputSource: generate_token/token

steps:
  - id: extract_fastq_1
    run: ../../tools/bio_client_download.cwl
    scatter: download_handle
    in:
      - id: config-file
        source: bioclient_config
      - id: download_handle
        source: fastq_1_gdc_id
      - id: file_size
        source: fastq_1_file_size
    out:
      - id: output

  - id: extract_fastq_2
    run: ../../tools/bio_client_download.cwl
    scatter: download_handle
    in:
      - id: config-file
        source: bioclient_config
      - id: download_handle
        source: fastq_2_gdc_id
      - id: file_size
        source: fastq_2_file_size
    out:
      - id: output

  - id: extract_fastq_2
    run: ../../tools/bio_client_download.cwl
    scatter: download_handle
    in:
      - id: config-file
        source: bioclient_config
      - id: download_handle
        source: fastq_2_gdc_id
      - id: file_size
        source: fastq_2_file_size
    out:
      - id: output

  - id: transform
    run: transform.cwl
    in:
      - id: bam_name
        source: bam_name
      - id: fastq_1
        source: extract_fastq_1/output
      - id: fastq_2
        source: extract_fastq_2/output
      - id: fastq_s
        source: extract_fastq_s/output
      - id: read_groups
        source: 
    out:
      - id: output_bam

  - id: load_bam
    run: ../../tools/bio_client_upload_pull_uuid.cwl
    in:
      - id: config-file
        source: bioclient_config
      - id: input
        source: transform/output_bam
      - id: upload-bucket
        source: bioclient_load_bucket
      - id: upload-key
        valueFrom: $(inputs.job_uuid)/$(inputs.input.basename)
      - id: job_uuid
        source: job_uuid
        valueFrom: $(null)
    out:
      - id: output

  - id: generate_token
    run: ../../tools/generate_load_token.cwl
    in:
      - id: load1
        source: load_bam/output
    out:
      - id: token
