#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/dnaseq_queue_status:1
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: created_bai_gdc_id
    type: string
    inputBinding:
      prefix: --created_bai_gdc_id

  - id: created_bam_gdc_id
    type: string
    inputBinding:
      prefix: --created_bam_gdc_id

  - id: created_sqlite_gdc_id
    type: string
    inputBinding:
      prefix: --created_sqlite_gdc_id

  - id: hostname
    type: string
    inputBinding:
      prefix: --hostname

  - id: host_ipaddress
    type: string
    inputBinding:
      prefix: --host_ipaddress

  - id: host_macaddress
    type: string
    inputBinding:
      prefix: --host_macaddress

  - id: input_bam_gdc_id
    type: string
    inputBinding:
      prefix: --input_bam_gdc_id

  - id: job_creation_uuid
    type: string
    inputBinding:
      prefix: --job_creation_uuid

  - id: program_id
    type: string
    inputBinding:
      prefix: --program_id

  - id: project_id
    type: string
    inputBinding:
      prefix: --project_id

  - id: known_snp_gdc_id
    type: string
    inputBinding:
      prefix: --known_snp_gdc_id

  - id: reference_amb_gdc_id
    type: string
    inputBinding:
      prefix: --reference_amb_gdc_id

  - id: reference_ann_gdc_id
    type: string
    inputBinding:
      prefix: --reference_ann_gdc_id

  - id: reference_bwt_gdc_id
    type: string
    inputBinding:
      prefix: --reference_bwt_gdc_id

  - id: reference_fa_gdc_id
    type: string
    inputBinding:
      prefix: --reference_fa_gdc_id

  - id: reference_fai_gdc_id
    type: string
    inputBinding:
      prefix: --reference_fai_gdc_id

  - id: reference_pac_gdc_id
    type: string
    inputBinding:
      prefix: --reference_pac_gdc_id

  - id: reference_sa_gdc_id
    type: string
    inputBinding:
      prefix: --reference_sa_gdc_id

  - id: run_uuid
    type: string
    inputBinding:
      prefix: --run_uuid

  - id: runner_cwl_path
    type: string
    inputBinding:
      prefix: --runner_cwl_path

  - id: runner_cwl_branch
    type: string
    inputBinding:
      prefix: --runner_cwl_branch

  - id: runner_cwl_repo
    type: string
    inputBinding:
      prefix: --runner_cwl_repo

  - id: runner_cwl_repo_hash
    type: string
    inputBinding:
      prefix: --runner_cwl_repo_hash

  - id: runner_job_path
    type: string
    inputBinding:
      prefix: --runner_job_path

  - id: runner_job_branch
    type: string
    inputBinding:
      prefix: --runner_job_branch

  - id: runner_job_repo
    type: string
    inputBinding:
      prefix: --runner_job_repo

  - id: runner_job_repo_hash
    type: string
    inputBinding:
      prefix: --runner_job_repo_hash

  - id: slurm_resource_cores
    type: string
    inputBinding:
      prefix: --slurm_resource_cores

  - id: slurm_resource_disk_gb
    type: string
    inputBinding:
      prefix: --slurm_resource_disk_gb

  - id: slurm_resource_mem_mb
    type: string
    inputBinding:
      prefix: --slurm_resource_mem_mb

  - id: status
    type: string
    inputBinding:
      prefix: --status

  - id: status_table
    type: string
    inputBinding:
      prefix: --status_table

  - id: thread_count
    type: string
    inputBinding:
      prefix: --thread_count

outputs:
  - id: log
    type: File
    outputBinding:
      glob: $(inputs.uuid+".log")

  - id: sqlite
    type: File
    outputBinding:
      glob: $(inputs.uuid+".db")

baseCommand: [/usr/local/bin/dnaseq_queue_status]
