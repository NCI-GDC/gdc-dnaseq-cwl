#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  - id: cwl_runner_branch
    type: string
  - id: cwl_runner_repo
    type: string
  - id: cwl_runner_url
    type: string
  - id: cwl_runner_job_branch
    type: string
  - id: cwl_runner_job_repo
    type: string
  - id: cwl_runner_job_url
    type: string
  - id: db_cred
    type: File
  - id: db_cred_section
    type: string
  - id: gdc_token
    type: File
  - id: input_bam_gdc_id
    type: string
  - id: input_bam_file_size
    type: long
  - id: input_bam_md5sum
    type: string
  - id: job_uuid
    type: string
  - id: slurm_runner_job_url
    type: string
  - id: slurm_resource_cores
    type: long
  - id: slurm_resource_disk_gigabytes
    type: long
  - id: slurm_resource_mem_megabytes
    type: long
  - id: status_table
    type: string
  - id: thread_count
    type: long
  - id: workflow_hash
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
    outputSource: status_complete/token

steps:
  - id: get_hostname
    run: ../../tools/emit_hostname.cwl
    in:
      []
    out:
      - id: output

  - id: get_host_ipaddress
    run: ../../tools/emit_host_ipaddress.cwl
    in:
      []
    out:
      - id: output

  - id: get_host_macaddress
    run: ../../tools/emit_host_mac.cwl
    in:
      []
    out:
      - id: output

  - id: get_cwl_runner_repo_hash
    run: ../../tools/emit_git_hash.cwl
    in:
      - id: repo
        source: cwl_runner_repo
      - id: branch
        source: cwl_runner_branch
    out:
      - id: output

  - id: get_cwl_runner_job_repo_hash
    run: ../../tools/emit_git_hash.cwl
    in:
      - id: repo
        source: cwl_runner_job_repo
      - id: branch
        source: cwl_runner_job_branch
    out:
      - id: output

  - id: status_running
    run: status_postgres.cwl
    in:
      - id: cwl_runner_url
        source: cwl_runner_url
      - id: cwl_runner_branch
        source: cwl_runner_branch
      - id: cwl_runner_repo
        source: cwl_runner_repo
      - id: cwl_runner_repo_hash
        source: get_cwl_runner_repo_hash/output
      - id: cwl_runner_job_branch
        source: cwl_runner_job_branch
      - id: cwl_runner_job_url
        source: cwl_runner_job_url
      - id: cwl_runner_job_repo
        source: cwl_runner_job_repo
      - id: cwl_runner_job_repo_hash
        source: get_cwl_runner_job_repo_hash/output
      - id: db_cred
        source: db_cred
      - id: db_cred_section
        source: db_cred_section
      - id: hostname
        source: get_hostname/output
      - id: host_ipaddress
        source: get_host_ipaddress/output
      - id: host_macaddress
        source: get_host_macaddress/output
      - id: input_bam_gdc_id
        source: input_bam_gdc_id
      - id: input_bam_file_size
        source: input_bam_file_size
      - id: input_bam_md5sum
        source: input_bam_md5sum
      - id: job_uuid
        source: job_uuid
      - id: slurm_resource_cores
        source: slurm_resource_cores
      - id: slurm_resource_disk_gigabytes
        source: slurm_resource_disk_gigabytes
      - id: slurm_resource_mem_megabytes
        source: slurm_resource_mem_megabytes
      - id: status
        valueFrom: "RUNNING"
      - id: step_token
        source: gdc_token
      - id: table_name
        source: status_table
      - id: thread_count
        source: thread_count
    out:
      - id: token

  - id: etl
    run: etl.cwl
    in:
      - id: gdc_token
        source: gdc_token
      - id: input_bam_gdc_id
        source: input_bam_gdc_id
      - id: start_token
        source: status_running/token
      - id: thread_count
        source: thread_count
      - id: job_uuid
        source: job_uuid
      - id: aws_config
        source: aws_config
      - id: aws_shared_credentials
        source: aws_shared_credentials
      - id: endpoint_json
        source: endpoint_json
      - id: load_bucket
        source: load_bucket
      - id: s3cfg_section
        source: s3cfg_section
    out:
      - id: token

  - id: status_complete
    run: status_postgres.cwl
    in:
      - id: cwl_runner_url
        source: cwl_runner_url
      - id: cwl_runner_branch
        source: cwl_runner_branch
      - id: cwl_runner_repo
        source: cwl_runner_repo
      - id: cwl_runner_repo_hash
        source: get_cwl_runner_repo_hash/output
      - id: cwl_runner_job_branch
        source: cwl_runner_job_branch
      - id: cwl_runner_job_url
        source: cwl_runner_job_url
      - id: cwl_runner_job_repo
        source: cwl_runner_job_repo
      - id: cwl_runner_job_repo_hash
        source: get_cwl_runner_job_repo_hash/output
      - id: db_cred
        source: db_cred
      - id: db_cred_section
        source: db_cred_section
      - id: hostname
        source: get_hostname/output
      - id: host_ipaddress
        source: get_host_ipaddress/output
      - id: host_macaddress
        source: get_host_macaddress/output
      - id: input_bam_gdc_id
        source: input_bam_gdc_id
      - id: input_bam_file_size
        source: input_bam_file_size
      - id: input_bam_md5sum
        source: input_bam_md5sum
      - id: job_uuid
        source: job_uuid
      - id: slurm_resource_cores
        source: slurm_resource_cores
      - id: slurm_resource_disk_gigabytes
        source: slurm_resource_disk_gigabytes
      - id: slurm_resource_mem_megabytes
        source: slurm_resource_mem_megabytes
      - id: status
        valueFrom: "COMPLETE"
      - id: step_token
        source: etl/token
      - id: table_name
        source: status_table
      - id: thread_count
        source: thread_count
    out:
      - id: token
