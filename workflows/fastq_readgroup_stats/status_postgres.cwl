#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: MultipleInputFeatureRequirement
  - class: StepInputExpressionRequirement

inputs:
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
  - id: hostname
    type: string
  - id: host_ipaddress
    type: string
  - id: host_macaddress
    type: string
  - id: indexd_sqlite_uuid
    type: string
  - id: input_bam_gdc_id
    type: string
  - id: input_bam_file_size
    type: long
  - id: input_bam_md5sum
    type: string
  - id: job_uuid
    type: string
  - id: slurm_resource_cores
    type: long
  - id: slurm_resource_disk_gigabytes
    type: long
  - id: slurm_resource_mem_megabytes
    type: long
  - id: status
    type: string
  - id: status_table
    type: string
  - id: step_token
    type: File
  - id: thread_count
    type: long

outputs:
  - id: token
    type: File
    outputSource: sqlite_to_postgres/log

steps:
  - id: emit_json
    run: ../../tools/emit_json.cwl
    in:
      - id: string_keys
        default: [
          "cwl_workflow_git_hash",
          "cwl_workflow_git_repo",
          "cwl_workflow_rel_path",
          "cwl_job_git_hash",
          "cwl_job_git_repo",
          "cwl_job_rel_path",
          "hostname",
          "host_ipaddress",
          "host_macaddress",
          "indexd_sqlite_uuid",
          "status",
          "job_uuid"
        ]
      - id: string_values
        source: [
          cwl_workflow_git_hash,
          cwl_workflow_git_repo,
          cwl_workflow_rel_path,
          cwl_job_git_hash,
          cwl_job_git_repo,
          cwl_job_rel_path,
          hostname,
          host_ipaddress,
          host_macaddress,
          indexd_sqlite_uuid,
          status,
          job_uuid
        ]
      - id: long_keys
        default: [
          "slurm_resource_cores",
          "slurm_resource_disk_gigabytes",
          "slurm_resource_mem_megabytes",
          "thread_count"
        ]
      - id: long_values
        source: [
          slurm_resource_cores,
          slurm_resource_disk_gigabytes,
          slurm_resource_mem_megabytes,
          thread_count
        ]
      - id: float_keys
        default: []
      - id: float_values
        default: []
    out:
      - id: output

  - id: json_to_sqlite
    run: ../../tools/json_to_sqlite.cwl
    in:
      - id: input_json
        source: emit_json/output
      - id: job_uuid
        source: job_uuid
      - id: table_name
        source: status_table
    out:
      - id: sqlite
      - id: log

  - id: sqlite_to_postgres
    run: ../../tools/sqlite_to_postgres_hirate.cwl
    in:
      - id: postgres_creds_path
        source: db_cred
      - id: ini_section
        source: db_cred_section
      - id: source_sqlite_path
        source: json_to_sqlite/sqlite
      - id: job_uuid
        source: job_uuid
    out:
      - id: log
