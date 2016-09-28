#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  - id: aws_config_file
    type: File
  - id: aws_shared_credentials_file
    type: File
  - id: bam_signpost_id
    type: string
  - id: db_cred_path
    type: File
  - id: db_cred_section
    type: string
  - id: db_snp_signpost_id
    type: string
  - id: endpoint_json
    type: File
  - id: load_bucket
    type: string
  - id: load_s3cfg_section
    type: string
  - id: reference_amb_signpost_id
    type: string
  - id: reference_ann_signpost_id
    type: string
  - id: reference_bwt_signpost_id
    type: string
  - id: reference_fa_signpost_id
    type: string
  - id: reference_fai_signpost_id
    type: string
  - id: reference_pac_signpost_id
    type: string
  - id: reference_sa_signpost_id
    type: string
  - id: repo
    type: string
  - id: repo_hash
    type: string
  - id: signpost_base_url
    type: string
  - id: status_table_name
    type: string
  - id: thread_count
    type: int
  - id: uuid
    type: string

outputs:
  - id: token
    type: File
    outputSource: status_complete/token

steps:
  - id: status_running
    run: ../status/status_postgres_workflow.cwl
    in:
      - id: ini_section
        source: db_cred_section
      - id: postgres_creds_path
        source: db_cred_path
      - id: repo
        source: repo
      - id: repo_hash
        source: repo_hash
      - id: status
        valueFrom: "RUNNING"
      - id: table_name
        source: status_table_name
      - id: uuid
        source: uuid
    out:
      - id: token

  - id: etl
    run: etl.cwl
    in:
      - id: aws_config_file
        source: aws_config_file
      - id: aws_shared_credentials_file
        source: aws_shared_credentials_file
      - id: bam_signpost_id
        source: bam_signpost_id
      - id: db_cred_path
        source: db_cred_path
      - id: db_snp_signpost_id
        source: db_snp_signpost_id
      - id: endpoint_json
        source: endpoint_json
      - id: load_bucket
        source: load_bucket
      - id: load_s3cfg_section
        source: load_s3cfg_section
      - id: reference_amb_signpost_id
        source: reference_amb_signpost_id
      - id: reference_ann_signpost_id
        source: reference_ann_signpost_id
      - id: reference_bwt_signpost_id
        source: reference_bwt_signpost_id
      - id: reference_fa_signpost_id
        source: reference_fa_signpost_id
      - id: reference_fai_signpost_id
        source: reference_fai_signpost_id
      - id: reference_pac_signpost_id
        source: reference_pac_signpost_id
      - id: reference_sa_signpost_id
        source: reference_sa_signpost_id
      - id: signpost_base_url
        source: signpost_base_url
      - id: thread_count
        source: thread_count
      - id: start_token
        source: status_running/token
      - id: uuid
        source: uuid
    out:
      - id: token
      - id: harmonized_bam_uri

  - id: status_complete
    run: ../status/status_postgres_workflow.cwl
    in:
      - id: ini_section
        source: db_cred_section
      - id: postgres_creds_path
        source: db_cred_path
      - id: repo
        source: repo
      - id: repo_hash
        source: repo_hash
      - id: s3_url
        source: etl/harmonized_bam_uri
      - id: status
        valueFrom: "COMPLETE"
      - id: table_name
        source: status_table_name
      - id: uuid
        source: uuid
    out:
      - id: token
