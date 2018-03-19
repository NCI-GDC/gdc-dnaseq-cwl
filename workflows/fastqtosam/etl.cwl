#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - $import: ../../tools/readgroup.yml
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
  - id: job_uuid
    type: string
  - id: readgroup_fastq_pe_uuid_list
    type:
      type: array
      items:  ../../tools/readgroup.yml#readgroup_fastq_pe_uuid
  - id: readgroup_fastq_se_list
    type:
      type: array
      items:  ../../tools/readgroup_no_pu.yaml#readgroup_fastq_se
  - id: readgroups_bam_list
    type: 
      type: array
      items: ../../tools/readgroup_no_pu.yaml#readgroups_bam
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
  - id: transform
    run: transform.cwl
    in:
      - id: bam_name
        source: bam_name
      - id: bioclient_config
        source: bioclient_config
      - id: readgroup_fastq_pe_list
        source: readgroup_fastq_pe_list
      - id: readgroup_fastq_se_list
        source: readgroup_fastq_se_list
      - id: readgroups_bam_list
        source: readgroups_bam_list
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
        valueFrom: job_uuid/bam_name
    out:
      - id: output

  - id: generate_token
    run: ../../tools/generate_load_token.cwl
    in:
      - id: load1
        source: load_bam/output
    out:
      - id: token
