#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - $import: ../../tools/readgroup_no_pu.yaml
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  - id: bam_name
    type: string
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
  - id: readgroup_pe_uuid
    type:
      type: array
      items:  ../../tools/readgroup_no_pu.yaml#readgroup_pe_uuid
  - id: readgroup_se_uuid
    type:
      type: array
      items:  ../../tools/readgroup_no_pu.yaml#readgroup_se_uuid
  - id: slurm_resource_cores
    type: long
  - id: slurm_resource_disk_gigabytes
    type: long
  - id: slurm_resource_mem_megabytes
    type: long
  - id: status_table
    type: string
  - id: job_uuid
    type: string
  - id: thread_count
    type: long

outputs:
  - id: indexd_bam_uuid
    type: string
    outputSource: emit_bam_uuid/output

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

  # - id: status_running
  #   run: status_postgres.cwl
  #   in:
  #     - id: cwl_workflow_git_hash
  #       source: cwl_workflow_git_hash
  #     - id: cwl_workflow_git_repo
  #       source: cwl_workflow_git_repo
  #     - id: cwl_workflow_rel_path
  #       source: cwl_workflow_rel_path
  #     - id: cwl_job_git_hash
  #       source: cwl_job_git_hash
  #     - id: cwl_job_git_repo
  #       source: cwl_job_git_repo
  #     - id: cwl_job_rel_path
  #       source: cwl_job_rel_path
  #     - id: db_cred
  #       source: db_cred
  #     - id: db_cred_section
  #       source: db_cred_section
  #     - id: hostname
  #       source: get_hostname/output
  #     - id: host_ipaddress
  #       source: get_host_ipaddress/output
  #     - id: host_macaddress
  #       source: get_host_macaddress/output
  #     - id: indexd_bam_uuid
  #       valueFrom: "NULL"
  #     - id: readgroup_pe_uuid
  #       source: readgroup_pe_uuid
  #     - id: readgroup_se_uuid
  #       source: readgroup_se_uuid
  #     - id: slurm_resource_cores
  #       source: slurm_resource_cores
  #     - id: slurm_resource_disk_gigabytes
  #       source: slurm_resource_disk_gigabytes
  #     - id: slurm_resource_mem_megabytes
  #       source: slurm_resource_mem_megabytes
  #     - id: status
  #       valueFrom: "RUNNING"
  #     - id: step_token
  #       source: bioclient_config
  #     - id: status_table
  #       source: status_table
  #     - id: job_uuid
  #       source: job_uuid
  #     - id: thread_count
  #       source: thread_count
  #   out:
  #     - id: token

  - id: etl
    run: etl.cwl
    in:
      - id: bam_name
        source: bam_name
      - id: bioclient_config
        source: bioclient_config
      - id: bioclient_load_bucket
        source: bioclient_load_bucket
      - id: job_uuid
        source: job_uuid
      - id: readgroup_pe_uuid
        source: readgroup_pe_uuid
      - id: readgroup_se_uuid
        source: readgroup_se_uuid
      - id: start_token
        source: bioclient_config #status_running/token
    out:
      - id: indexd_bam_json
      - id: token

  - id: emit_bam_uuid
    run: ../../tools/emit_json_value.cwl
    in:
      - id: input
        source: etl/indexd_bam_json
      - id: key
        valueFrom: did
    out:
      - id: output

  # - id: status_complete
  #   run: status_postgres.cwl
  #   in:
  #     - id: cwl_workflow_git_hash
  #       source: cwl_workflow_git_hash
  #     - id: cwl_workflow_git_repo
  #       source: cwl_workflow_git_repo
  #     - id: cwl_workflow_rel_path
  #       source: cwl_workflow_rel_path
  #     - id: cwl_job_git_hash
  #       source: cwl_job_git_hash
  #     - id: cwl_job_git_repo
  #       source: cwl_job_git_repo
  #     - id: cwl_job_rel_path
  #       source: cwl_job_rel_path
  #     - id: db_cred
  #       source: db_cred
  #     - id: db_cred_section
  #       source: db_cred_section
  #     - id: hostname
  #       source: get_hostname/output
  #     - id: host_ipaddress
  #       source: get_host_ipaddress/output
  #     - id: host_macaddress
  #       source: get_host_macaddress/output
  #     - id: indexd_bam_uuid
  #       source: emit_bam_uuid/output
  #     - id: readgroup_pe_uuid
  #       source: readgroup_pe_uuid
  #     - id: readgroup_se_uuid
  #       source: readgroup_se_uuid
  #     - id: slurm_resource_cores
  #       source: slurm_resource_cores
  #     - id: slurm_resource_disk_gigabytes
  #       source: slurm_resource_disk_gigabytes
  #     - id: slurm_resource_mem_megabytes
  #       source: slurm_resource_mem_megabytes
  #     - id: status
  #       valueFrom: "COMPLETE"
  #     - id: step_token
  #       source: etl/token
  #     - id: status_table
  #       source: status_table
  #     - id: job_uuid
  #       source: job_uuid
  #     - id: thread_count
  #       source: thread_count
  #   out:
  #     - id: token
