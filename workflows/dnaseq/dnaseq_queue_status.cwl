#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/dnaseq_queue_status:183b191b413088e3bc3378f4e0f9e9d2bcb0430b48c4db66ad35f88c6266492a
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
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

  - id: input_bam_file_size
    type: long
    inputBinding:
      prefix: --input_bam_file_size

  - id: input_bam_md5sum
    type: string
    inputBinding:
      prefix: --input_bam_md5sum

  - id: job_creation_uuid
    type: string
    inputBinding:
      prefix: --job_creation_uuid

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

  - id: runner_cwl_uri
    type: string
    inputBinding:
      prefix: --runner_cwl_uri

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

  - id: runner_job_uri
    type: string
    inputBinding:
      prefix: --runner_job_uri

  - id: slurm_resource_cores
    type: int
    inputBinding:
      prefix: --slurm_resource_cores

  - id: slurm_resource_disk_gb
    type: int
    inputBinding:
      prefix: --slurm_resource_disk_gb

  - id: slurm_resource_mem_mb
    type: int
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
    type: int
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
