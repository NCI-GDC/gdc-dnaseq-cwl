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
  - id: cwl_task_git_branch
    type: string
  - id: cwl_task_git_hash
    type: string
  - id: cwl_task_git_repo
    type: string
  - id: cwl_task_rel_path
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
  - id: reference_dict_gdc_id
    type: string
  - id: reference_fa_gdc_id
    type: string
  - id: reference_fai_gdc_id
    type: string
  - id: reference_pac_gdc_id
    type: string
  - id: reference_sa_gdc_id
    type: string
  - id: s3_bam_url
    type: string
  - id: s3_bai_url
    type: string
  - id: s3_mirna_profiling_tar_url
    type: string
  - id: s3_mirna_profiling_isoforms_quant_url
    type: string
  - id: s3_mirna_profiling_mirnas_quant_url
    type: string
  - id: slurm_resource_cores
    type: long
  - id: slurm_resource_disk_gigabytes
    type: long
  - id: slurm_resource_mem_megabytes
    type: long
  - id: status
    type: string
  - id: step_token
    type: File
  - id: table_name 
    type: string
  - id: task_uuid
    type: string
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
          "cwl_task_git_branch",
          "cwl_task_git_hash",
          "cwl_task_git_repo",
          "cwl_task_rel_path",
          "hostname",
          "host_ipaddress",
          "host_macaddress",
          "input_bam_gdc_id",
          "input_bam_md5sum",
          "known_snp_gdc_id",
          "known_snp_index_gdc_id",
          "reference_amb_gdc_id",
          "reference_ann_gdc_id",
          "reference_bwt_gdc_id",
          "reference_dict_gdc_id",
          "reference_fa_gdc_id",
          "reference_fai_gdc_id",
          "reference_pac_gdc_id",
          "reference_sa_gdc_id",
          "s3_bam_url",
          "s3_bai_url",
          "s3_mirna_profiling_tar_url",
          "s3_mirna_profiling_isoforms_quant_url",
          "s3_mirna_profiling_mirnas_quant_url",
          "status",
          "task_uuid"
        ]
      - id: string_values
        source: [
          cwl_workflow_git_hash,
          cwl_workflow_git_repo,
          cwl_workflow_rel_path,
          cwl_task_git_branch,
          cwl_task_git_hash,
          cwl_task_git_repo,
          cwl_task_rel_path,
          hostname,
          host_ipaddress,
          host_macaddress,
          input_bam_gdc_id,
          input_bam_md5sum,
          known_snp_gdc_id,
          known_snp_index_gdc_id,
          reference_amb_gdc_id,
          reference_ann_gdc_id,
          reference_bwt_gdc_id,
          reference_dict_gdc_id,
          reference_fa_gdc_id,
          reference_fai_gdc_id,
          reference_pac_gdc_id,
          reference_sa_gdc_id,
          s3_bam_url,
          s3_bai_url,
          s3_mirna_profiling_tar_url,
          s3_mirna_profiling_isoforms_quant_url,
          s3_mirna_profiling_mirnas_quant_url,
          s3_sqlite_url,
          status,
          task_uuid
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
      - id: task_uuid
        source: task_uuid
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
      - id: task_uuid
        source: task_uuid
    out:
      - id: log
