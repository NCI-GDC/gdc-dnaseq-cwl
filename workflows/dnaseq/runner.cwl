#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  - id: db_cred
    type: File
  - id: db_cred_section
    type: string
  - id: gdc_program
    type: string
  - id: gdc_project
    type: string
  - id: gdc_token
    type: File
  - id: input_bam_gdc_id
    type: string
  - id: input_bam_file_size
    type: string
  - id: job_creation_uuid
    type: string
  - id: known_snp_gdc_id
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
  - id: runner_cwl_branch
    type: string
  - id: runner_cwl_path
    type: string
  - id: runner_cwl_repo
    type: string
  - id: runner_job_branch
    type: string
  - id: runner_job_path
    type: string
  - id: runner_job_repo
    type: string
  - id: slurm_resource_cores
    source: int
  - id: slurm_resource_disk_gb
    source: int
  - id: slurm_resource_mem_mb
    source: int
  - id: status_table
    type: string
  - id: thread_count
    type: int

outputs:
  - id: token
    type: File
    outputSource: status_complete/token

steps:
  - id: get_run_uuid
    run: ../../tools/emit_uuid.cwl
    in:
      []
    out:
      - id: output

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

  - id: get_runner_cwl_repo_hash
    run: ../../tools/emit_git_hash.cwl
    in:
      - id: repo
        source: runner_cwl_repo
      - id: branch
        source: runner_cwl_branch
    out:
      - id: output

  - id: get_runner_job_repo_hash
    run: ../../tools/emit_git_hash.cwl
    in:
      - id: repo
        source: runner_job_repo
      - id: branch
        source: runner_job_branch
    out:
      - id: output

  - id: status_running
    run: status_postgres.cwl
    in:
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
      - id: job_creation_uuid
        source: job_creation_uuid
      - id: known_snp_gdc_id
        source: known_snp_gdc_id
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
        source: get_run_uuid/output
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
        valueFrom: "RUNNING"
      - id: status_table
        source: status_table
      - id: thread_count
        source: thread_count
    out:
      - id: token

  - id: etl
    run: etl.cwl
    in:
      - id: input_bam_gdc_id
        source: input_bam_gdc_id
      - id: known_snp_gdc_id
        source: known_snp_gdc_id
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
      - id: start_token
        source: status_running/token
      - id: thread_count
        source: thread_count
      - id: run_uuid
        source: get_run_uuid/output
    out:
      - id: token
      - id: harmonized_bam_uri

  - id: status_complete
    run: ../status/status_postgres_workflow.cwl
    in:
      - id: db_cred
        source: db_cred
      - id: db_cred_section
        source: db_cred_section
      - id: gdc_project
        source: gdc_project
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
      - id: job_creation_uuid
        source: job_creation_uuid
      - id: known_snp_gdc_id
        source: known_snp_gdc_id
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
        source: get_run_uuid/output
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
        valueFrom: "COMPLETE"
      - id: status_table
        source: status_table
      - id: thread_count
        source: thread_count
    out:
      - id: token
