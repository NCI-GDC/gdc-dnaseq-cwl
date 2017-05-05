#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

inputs:
  - id: created_bai_gdc_id
    type: string
  - id: created_bam_gdc_id
    type: string
  - id: created_sqlite_gdc_id
    type: string
  - id: db_cred
    type: File
  - id: db_cred_section
    type: string
  - id: hostname
    type: string
  - id: host_ipadress
    type: string
  - id: host_macaddress
    type: string
  - id: input_bam_gdc_id
    type: string
  - id: job_creation_uuid
    type: string
  - id: known_snp_gdc_id
    type: string
  - id: program_id
    type: string
  - id: project_id
    type: string
  - id: reference_amb_gdc_id
    type: string
  - id: reference_ann_gdc_id
    type: string
  - id: reference_bwt_gdc_id
    type: string
  - id: reference_fa_gdc_id
    type: string
  - id: reference_fai_gdc_id
    type: string
  - id: reference_pac_gdc_id
    type: string
  - id: reference_sa_gdc_id
    type: string
  - id: run_uuid
    type: string
  - id: runner_cwl_path
    type: string
  - id: runner_cwl_branch
    type: string
  - id: runner_cwl_repo
    type: string
  - id: runner_cwl_repo_hash
    type: string
  - id: runner_job_path
    type: string
  - id: runner_job_branch
    type: string
  - id: runner_job_repo
    type: string
  - id: runner_job_repo_hash
    type: string
  - id: slurm_resource_cores
    type: int
  - id: slurm_resource_disk_gb
    type: int
  - id: slurm_resource_mem_mb
    type: int
  - id: status
    valueFrom: status
  - id: status_table
    valueFrom: status_table
  - id: thread_count
    type: thread_count

outputs:
  - id: token
    type: File
    outputSource: sqlite_to_postgres/log

steps:
  - id: queue_status
    run: queue_status.cwl
    in:
      - id: created_bai_gdc_id
        source: created_bai_gdc_id
      - id: created_bam_gdc_id
        source: created_bam_gdc_id
      - id: created_sqlite_gdc_id
        source: created_sqlite_gdc_id
      - id: hostname
        source: get_hostname/output
      - id: host_ipaddress
        source: get_host_ipaddress/output
      - id: host_macaddress
        source: get_host_macaddress/output
      - id: input_bam_gdc_id
        source: input_bam_gdc_id
      - id: job_creation_uuid
        source: job_creation_uuid
      - id: known_snp_gdc_id
        source: known_snp_gdc_id
      - id: program_id
        source: program_id
      - id: project_id
        source: project_id
      - id: reference_amb_gdc_id
        source: reference_amb_gdc_id
      - id: reference_ann_gdc_id
        source: reference_ann_gdc_id
      - id: reference_bwt_gdc_id
        source: reference_bwt_gdc_id
      - id: reference_fa_gdc_id
        source: reference_fa_gdc_id
      - id: reference_fai_gdc_id
        source: reference_fai_gdc_id
      - id: reference_pac_gdc_id
        source: reference_pac_gdc_id
      - id: reference_sa_gdc_id
        source: reference_sa_gdc_id
      - id: run_uuid
        source: run_uuid
      - id: runner_cwl_path
        source: runner_cwl_path
      - id: runner_cwl_branch
        source: runner_cwl_branch
      - id: runner_cwl_repo
        source: runner_cwl_repo
      - id: runner_cwl_repo_hash
        source: get_runner_cwl_repo_hash/output
      - id: runner_job_path
        source: runner_job_path
      - id: runner_job_branch
        source: runner_job_branch
      - id: runner_job_repo
        source: runner_job_repo
      - id: runner_job_repo_hash
        source: get_runner_job_repo_hash/output
      - id: slurm_resource_cores
        source: slurm_resource_cores
      - id: slurm_resource_disk_gb
        source: slurm_resource_disk_gb
      - id: slurm_resource_mem_mb
        source: slurm_resource_mem_mb
      - id: status
        source: status
      - id: status_table
        source: status_table
      - id: thread_count
        source: thread_count
    out:
      - id: log
      - id: sqlite

  - id: sqlite_to_postgres
    run: ../../tools/sqlite_to_postgres_hirate.cwl
    in:
      - id: db_cred
        source: db_cred
      - id: db_cred_section
        source: db_cred_section
      - id: source_sqlite_path
        source: queue_status/sqlite
      - id: uuid
        source: run_uuid
    out:
      - id: log
