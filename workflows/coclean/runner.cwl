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
  - id: bam_normal_signpost_id
    type: string
  - id: bam_tumor_signpost_id
    type: string
  - id: db_cred_path
    type: File
  - id: db_cred_section
    type: string
  - id: endpoint_json
    type: File
  - id: known_indel_index_signpost_id
    type: string
  - id: known_indel_signpost_id
    type: string
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
    run: ../tools/get_uuid.cwl
    in:
      []
    out:
      id: uuid

  - id: get_hostname
    run: ../tools/get_hostname.cwl
    in:
      []
    out:
      id: hostname

  - id: get_host_ipaddress
    run: ../tools/get_host_ipaddress.cwl
    in:
      []
    out:
      id: ipaddress

  - id: get_host_mac
    run: ../tools/get_host_mac.cwl
    in:
      []
    out:
      id: mac

  - id: status_running
    run: status_postgres_workflow.cwl
    in:
      - id: bam_normal_signpost_id
        source: bam_normal_signpost_id
      - id: bam_tumor_signpost_id
        source: bam_tumor_signpost_id
      - id: hostname
        source: get_hostname/hostname
      - id: host_ipaddress
        source: get_host_ipaddress/ipaddress
      - id: host_mac
        source: get_host_mac/mac
      - id: ini_section
        source: db_cred_section
      - id: known_indel_signpost_id
        type: string
      - id: known_snp_signpost_id
        type: string
      - id: num_threads
        source: num_threads
      - id: postgres_creds_path
        source: db_cred_path
      - id: reference_fa_signpost_id
        type: string
      - id: repo
        source: repo
      - id: repo_hash
        source: repo_hash
      - id: status
        valueFrom: "RUNNING"
      - id: table_name
        source: status_table_name
      - id: uuid
        source: get_run_uuid/uuid
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
        source: get_run_uuid/uuid
    out:
      - id: bam_uri
      - id: token

  - id: status_complete
    run: ../status/status_postgres_workflow.cwl
    in:
      - id: bam_normal_signpost_id
        source: bam_normal_signpost_id
      - id: bam_tumor_signpost_id
        source: bam_tumor_signpost_id
      - id: hostname
        source: get_hostname/hostname
      - id: host_ipaddress
        source: get_host_ipaddress/ipaddress
      - id: host_mac
        source: get_host_mac/mac
      - id: ini_section
        source: db_cred_section
      - id: known_indel_signpost_id
        type: string
      - id: known_snp_signpost_id
        type: string
      - id: num_threads
        source: num_threads
      - id: postgres_creds_path
        source: db_cred_path
      - id: reference_fa_signpost_id
        type: string
      - id: repo
        source: repo
      - id: repo_hash
        source: repo_hash
      - id: s3_url
        source: etl/bam_uri
      - id: status
        valueFrom: "COMPLETE"
      - id: table_name
        source: status_table_name
      - id: uuid
        source: get_run_uuid/uuid
    out:
      - id: token
