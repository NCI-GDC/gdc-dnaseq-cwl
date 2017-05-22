#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

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
  - id: known_snp_gdc_id
    type: string
  - id: known_snp_index_gdc_id
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
    type: int
  - id: slurm_resource_disk_gb
    type: int
  - id: slurm_resource_mem_mb
    type: int
  - id: status
    type: string
  - id: status_table
    type: string
  - id: step_token
    type: File
  - id: thread_count
    type: int

outputs:
  - id: token
    type: File
    outputSource: sqlite_to_postgres/log

steps:
  - id: dnaseq_queue_status
    run: dnaseq_queue_status.cwl
    in:
      - id: hostname
        source: hostname
      - id: host_ipaddress
        source: host_ipaddress
      - id: host_macaddress
        source: host_macaddress
      - id: input_bam_gdc_id
        source: input_bam_gdc_id
      - id: input_bam_file_size
        source: input_bam_file_size
      - id: input_bam_md5sum
        source: input_bam_md5sum
      - id: job_creation_uuid
        source: job_creation_uuid
      - id: known_snp_gdc_id
        source: known_snp_gdc_id
      - id: known_snp_index_gdc_id
        source: known_snp_index_gdc_id
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
      - id: runner_cwl_branch
        source: runner_cwl_branch
      - id: runner_cwl_repo
        source: runner_cwl_repo
      - id: runner_cwl_repo_hash
        source: runner_cwl_repo_hash
      - id: runner_cwl_uri
        source: runner_cwl_uri
      - id: runner_job_branch
        source: runner_job_branch
      - id: runner_job_repo
        source: runner_job_repo
      - id: runner_job_repo_hash
        source: runner_job_repo_hash
      - id: runner_job_uri
        source: runner_job_cwl_uri
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
      - id: postgres_creds_path
        source: db_cred
      - id: ini_section
        source: db_cred_section
      - id: source_sqlite_path
        source: dnaseq_queue_status/sqlite
      - id: uuid
        source: run_uuid
    out:
      - id: log
