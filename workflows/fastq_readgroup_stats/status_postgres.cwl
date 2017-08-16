#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: MultipleInputFeatureRequirement
  - class: StepInputExpressionRequirement

inputs:
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
  - id: job_creation_uuid
    type: string
  - id: run_uuid
    type: string
  - id: runner_cwl_branch
    type: string
  - id: runner_cwl_repo
    type: string
  - id: runner_cwl_repo_hash
    type: string
  - id: runner_cwl_uri
    type: string
  - id: runner_job_branch
    type: string
  - id: runner_job_cwl_uri
    type: string
  - id: runner_job_repo
    type: string
  - id: runner_job_repo_hash
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
          "hostname",
          "host_ipaddress",
          "host_macaddress",
          "input_bam_gdc_id",
          "input_bam_md5sum",
          "job_creation_uuid",
          "run_uuid",
          "runner_cwl_branch",
          "runner_cwl_repo",
          "runner_cwl_repo_hash",
          "runner_cwl_uri",
          "runner_job_branch",
          "runner_job_repo",
          "runner_job_repo_hash",
          "runner_job_cwl_uri",
          "status"
        ]
      - id: string_values
        source: [
          hostname,
          host_ipaddress,
          host_macaddress,
          input_bam_gdc_id,
          input_bam_md5sum,
          job_creation_uuid,
          run_uuid,
          runner_cwl_branch,
          runner_cwl_repo,
          runner_cwl_repo_hash,
          runner_cwl_uri,
          runner_job_branch,
          runner_job_repo,
          runner_job_repo_hash,
          runner_job_cwl_uri,
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
          slurm_resource_disk_gb,
          slurm_resource_mem_mb,
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
      - id: run_uuid
        source: run_uuid
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
        source: run_uuid
    out:
      - id: log
