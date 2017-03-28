#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

inputs:
  - id: bam_signpost_id
    type: string
  - id: bam_uuid
    type: ["null", string]
  - id: hostname
    type: string
  - id: host_ipaddress
    type: string
  - id: host_mac
    type: string
  - id: ini_section
    type: string
  - id: job_creation_uuid
    type: string
  - id: job_path
    type: string
  - id: known_snp_signpost_id
    type: string
  - id: num_threads
    type: int
  - id: postgres_creds_path
    type: File
  - id: reference_fa_signpost_id
    type: string
  - id: run_uuid
    type: string
  - id: runner_cwl_path
    type: string
  - id: runner_repo_hash
    type: string
  - id: s3_bam_url
    type: ["null", string]
  - id: slurm_resource_core_count
    type: int
  - id: slurm_resource_disk_gibibytes
    type: int
  - id: slurm_resource_mem_mebibytes
    type: int
  - id: status
    type: string
  - id: table_name
    type: string

outputs:
  - id: token
    type: File
    outputSource: sqlite_to_postgres/log

steps:
  - id: queue_status
    run: ../../tools/queue_bqsr_status.cwl
    in:
      - id: bam_signpost_id
        source: bam_signpost_id
      - id: bam_uuid
        source: bam_uuid
      - id: hostname
        source: hostname
      - id: host_ipaddress
        source: host_ipaddress
      - id: host_mac
        source: host_mac
      - id: job_creation_uuid
        source: job_creation_uuid
      - id: job_path
        source: job_path
      - id: known_snp_signpost_id
        source: known_snp_signpost_id
      - id: num_threads
        source: num_threads
      - id: reference_fa_signpost_id
        source: reference_fa_signpost_id
      - id: runner_cwl_path
        source: runner_cwl_path
      - id: runner_repo_hash
        source: runner_repo_hash
      - id: run_uuid
        source: run_uuid
      - id: s3_bam_url
        source: s3_bam_url
      - id: slurm_resource_core_count
        source: slurm_resource_core_count
      - id: slurm_resource_disk_gibibytes
        source: slurm_resource_disk_gibibytes
      - id: slurm_resource_mem_mebibytes
        source: slurm_resource_mem_mebibytes
      - id: status
        source: status
      - id: table_name
        source: table_name
    out:
      - id: log
      - id: sqlite

  - id: sqlite_to_postgres
    run: ../../tools/sqlite_to_postgres_hirate.cwl
    in:
      - id: ini_section
        source: ini_section
      - id: postgres_creds_path
        source: postgres_creds_path
      - id: source_sqlite_path
        source: queue_status/sqlite
      - id: uuid
        source: run_uuid
    out:
      - id: log
