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
  - id: cwl_workflow_git_hash
    type: string
  - id: cwl_workflow_git_repo
    type: string
  - id: cwl_workflow_rel_path
    type: string
  - id: cwl_job_git_hash
    type: string
  - id: cwl_job_git_repo
    type: string
  - id: cwl_job_rel_path
    type: string
  - id: db_cred
    type: File
  - id: db_cred_section
    type: string
  - id: job_uuid
    type: string
  - id: input_bam_gdc_id
    type: string
  - id: input_bam_file_size
    type: long
  - id: input_bam_md5sum
    type: string
  - id: slurm_resource_cores
    type: long
  - id: slurm_resource_disk_gigabytes
    type: long
  - id: slurm_resource_mem_megabytes
    type: long
  - id: status_table
    type: string
  - id: task_uuid
    type: string
  - id: thread_count
    type: long

outputs:
  []
  # - id: indexd_sqlite_uuid
  #   type: string
  #   outputSource: emit_sqlite_uuid/output

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

  - id: status_running
    run: status_postgres.cwl
    in:
      - id: cwl_workflow_git_hash
        source: cwl_workflow_git_hash
      - id: cwl_workflow_git_repo
        source: cwl_workflow_git_repo
      - id: cwl_workflow_rel_path
        source: cwl_workflow_rel_path
      - id: cwl_job_git_hash
        source: cwl_job_git_hash
      - id: cwl_job_git_repo
        source: cwl_job_git_repo
      - id: cwl_job_rel_path
        source: cwl_job_rel_path
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
      - id: indexd_sqlite_uuid
        valueFrom: "NULL"
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
      - id: status_table
        source: status_table
      - id: step_token
        source: bioclient_config
      - id: thread_count
        source: thread_count
    out:
      - id: token

  - id: etl
    run: etl.cwl
    in:
      - id: bioclient_config
        source: bioclient_config
      - id: bioclient_load_bucket
        source: bioclient_load_bucket
      - id: input_bam_gdc_id
        source: input_bam_gdc_id
      - id: input_bam_file_size
        source: input_bam_file_size
      - id: start_token
        source: status_running/token
      - id: thread_count
        source: thread_count
      - id: job_uuid
        source: job_uuid
    out:
      - id: indexd_sqlite_uuid

  - id: status_complete
    run: status_postgres.cwl
    in:
      - id: cwl_workflow_git_hash
        source: cwl_workflow_git_hash
      - id: cwl_workflow_git_repo
        source: cwl_workflow_git_repo
      - id: cwl_workflow_rel_path
        source: cwl_workflow_rel_path
      - id: cwl_job_git_hash
        source: cwl_job_git_hash
      - id: cwl_job_git_repo
        source: cwl_job_git_repo
      - id: cwl_job_rel_path
        source: cwl_job_rel_path
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
      - id: indexd_sqlite_uuid
        valueFrom: etl/indexd_sqlite_uuid
      - id: input_bam_gdc_id
        source: input_bam_gdc_id
      - id: input_bam_file_size
        source: input_bam_file_size
      - id: input_bam_md5sum
        source: input_bam_md5sum
      - id: slurm_resource_cores
        source: slurm_resource_cores
      - id: slurm_resource_disk_gigabytes
        source: slurm_resource_disk_gigabytes
      - id: slurm_resource_mem_megabytes
        source: slurm_resource_mem_megabytes
      - id: status
        valueFrom: "COMPLETE"
      - id: step_token
        source: status_running/token
      - id: status_table
        source: status_table
      - id: job_uuid
        source: job_uuid
      - id: thread_count
        source: thread_count
    out:
      - id: token
