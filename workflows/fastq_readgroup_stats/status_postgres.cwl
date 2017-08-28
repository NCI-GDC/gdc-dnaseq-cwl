#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: MultipleInputFeatureRequirement
  - class: StepInputExpressionRequirement

inputs:
  - id: cwl_runner_repo
    type: string
  - id: cwl_runner_repo_hash
    type: string
  - id: cwl_runner_url
    type: string
  - id: cwl_runner_job_branch
    type: string
  - id: cwl_runner_job_url
    type: string
  - id: cwl_runner_job_repo
    type: string
  - id: cwl_runner_job_repo_hash
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
  - id: table_name
    type: string
  - id: s3_sqlite_url
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
          "cwl_runner_repo",
          "cwl_runner_repo_hash",
          "cwl_runner_url",
          "cwl_runner_job_branch",
          "cwl_runner_job_repo",
          "cwl_runner_job_repo_hash",
          "cwl_runner_job_url",
          "hostname",
          "host_ipaddress",
          "host_macaddress",
          "input_bam_gdc_id",
          "input_bam_md5sum",
          "job_uuid",
          "s3_sqlite_url",
          "status"
        ]
      - id: string_values
        source: [
          cwl_runner_repo,
          cwl_runner_repo_hash,
          cwl_runner_url,
          cwl_runner_job_branch,
          cwl_runner_job_repo,
          cwl_runner_job_repo_hash,
          cwl_runner_job_url,
          hostname,
          host_ipaddress,
          host_macaddress,
          input_bam_gdc_id,
          input_bam_md5sum,
          job_uuid,
          s3_sqlite_url,
          status
        ]
      - id: long_keys
        default: [
          "input_bam_file_size",
          "slurm_resource_cores",
          "slurm_resource_disk_gigabytes",
          "slurm_resource_mem_megabytes",
          "thread_count"
        ]
      - id: long_values
        source: [
          input_bam_file_size,
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
        source: table_name
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
      - id: uuid
        source: job_uuid
    out:
      - id: log
