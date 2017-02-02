#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  - id: aws_config
    type: File
  - id: aws_shared_credentials
    type: File
  - id: bam_signpost_id
    type: string
  - id: db_cred_path
    type: File
  - id: db_cred_section
    type: string
  - id: endpoint_json
    type: File
  - id: known_snp_index_signpost_id
    type: string
  - id: known_snp_signpost_id
    type: string
  - id: load_bucket
    type: string
  - id: load_s3cfg_section
    type: string
  - id: num_threads
    type: int
  - id: reference_dict_signpost_id
    type: string
  - id: reference_fa_signpost_id
    type: string
  - id: reference_fai_signpost_id
    type: string
  - id: repo
    type: string
  - id: repo_hash
    type: string
  - id: signpost_base_url
    type: string
  - id: status_table_name
    type: string

outputs:
  - id: token
    type: File
    outputSource: status_complete/token

steps:
  - id: get_run_uuid
    run: ../../tools/get_uuid.cwl
    in:
      []
    out:
      - id: uuid

  - id: get_hostname
    run: ../../tools/get_hostname.cwl
    in:
      []
    out:
      - id: output

  - id: get_host_ipaddress
    run: ../../tools/get_host_ipaddress.cwl
    in:
      []
    out:
      - id: output

  - id: get_host_mac
    run: ../../tools/get_host_mac.cwl
    in:
      []
    out:
      - id: output

  - id: emit_run_uuid
    run: ../../tools/emit_file_string.cwl
    in:
      - id: input
        source: get_run_uuid/uuid
    out:
      - id: output

  - id: emit_hostname
    run: ../../tools/emit_file_string.cwl
    in:
      - id: input
        source: get_hostname/output
    out:
      - id: output

  - id: emit_host_ipaddress
    run: ../../tools/emit_file_string.cwl
    in:
      - id: input
        source: get_host_ipaddress/output
    out:
      - id: output

  - id: emit_host_mac
    run: ../../tools/emit_file_string.cwl
    in:
      - id: input
        source: get_host_mac/output
    out:
      - id: output

  - id: status_running
    run: status_postgres_workflow.cwl
    in:
      - id: bam_signpost_id
        source: bam_signpost_id
      - id: hostname
        source: emit_hostname/output
      - id: host_ipaddress
        source: emit_host_ipaddress/output
      - id: host_mac
        source: emit_host_mac/output
      - id: ini_section
        source: db_cred_section
      - id: known_snp_signpost_id
        source: known_snp_signpost_id
      - id: num_threads
        source: num_threads
      - id: postgres_creds_path
        source: db_cred_path
      - id: reference_fa_signpost_id
        source: reference_fa_signpost_id
      - id: repo
        source: repo
      - id: repo_hash
        source: repo_hash
      - id: run_uuid
        source: emit_run_uuid/output
      - id: status
        valueFrom: "RUNNING"
      - id: table_name
        source: status_table_name
    out:
      - id: token

  - id: etl
    run: etl.cwl
    in:
      - id: aws_config
        source: aws_config
      - id: aws_shared_credentials
        source: aws_shared_credentials
      - id: bam_signpost_id
        source: bam_signpost_id
      - id: endpoint_json
        source: endpoint_json
      - id: known_snp_index_signpost_id
        source: known_snp_index_signpost_id
      - id: known_snp_signpost_id
        source: known_snp_signpost_id
      - id: load_bucket
        source: load_bucket
      - id: load_s3cfg_section
        source: load_s3cfg_section
      - id: num_threads
        source: num_threads
      - id: reference_dict_signpost_id
        source: reference_dict_signpost_id
      - id: reference_fa_signpost_id
        source: reference_fa_signpost_id
      - id: reference_fai_signpost_id
        source: reference_fai_signpost_id
      - id: run_uuid
        source: emit_run_uuid/output
      - id: signpost_base_url
        source: signpost_base_url
      - id: start_token
        source: status_running/token
    out:
      - id: bam_uuid
      - id: s3_bam_url
      - id: token

  - id: status_complete
    run: status_postgres_workflow.cwl
    in:
      - id: bam_signpost_id
        source: bam_signpost_id
      - id: bam_uuid
        source: etl/bam_uuid
      - id: hostname
        source: emit_hostname/output
      - id: host_ipaddress
        source: emit_host_ipaddress/output
      - id: host_mac
        source: emit_host_mac/output
      - id: ini_section
        source: db_cred_section
      - id: known_snp_signpost_id
        source: known_snp_signpost_id
      - id: num_threads
        source: num_threads
      - id: postgres_creds_path
        source: db_cred_path
      - id: reference_fa_signpost_id
        source: reference_fa_signpost_id
      - id: repo
        source: repo
      - id: repo_hash
        source: repo_hash
      - id: s3_bam_url
        source: etl/s3_bam_url
      - id: status
        valueFrom: "COMPLETE"
      - id: table_name
        source: status_table_name
      - id: run_uuid
        source: emit_run_uuid/output
    out:
      - id: token
