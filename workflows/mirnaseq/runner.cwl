#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: SubworkflowFeatureRequirement

inputs:
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
  - id: slurm_resource_cores
    type: long
  - id: slurm_resource_disk_gigabytes
    type: long
  - id: slurm_resource_mem_megabytes
    type: long
  - id: status_table
    type: string
  - id: task_uuid
    type: string
  - id: thread_count
    type: long

outputs:
  - id: indexd_bam_uuid
    type: string
    outputSource: emit_bam_uuid/output
  - id: indexd_bai_uuid
    type: string
    outputSource: emit_bai_uuid/output
  - id: indexd_mirna_profiling_tar_uuid
    type: string
    outputSource: emit_mirna_profiling_tar_uuid/output
  - id: indexd_mirna_profiling_isoforms_quant_uuid
    type: string
    outputSource: emit_mirna_profiling_isoforms_quant_uuid/output
  - id: indexd_mirna_profiling_mirnas_quant_uuid
    type: string
    outputSource: emit_mirna_profiling_mirnas_quant_uuid/output
  - id: indexd_sqlite_uuid
    type: string
    outputSource: emit_sqlite_uuid/output

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

  - id: status_running
    run: status_postgres.cwl
    in:
      - id: cwl_workflow_git_hash
        source: cwl_workflow_git_hash
      - id: cwl_workflow_git_repo
        source: cwl_workflow_git_repo
      - id: cwl_workflow_rel_path
        source: cwl_workflow_rel_path
      - id: cwl_task_git_hash
        source: cwl_task_git_hash
      - id: cwl_task_git_repo
        source: cwl_task_git_repo
      - id: cwl_task_rel_path
        source: cwl_task_rel_path
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
      - id: reference_dict_gdc_id
        source: reference_dict_gdc_id
      - id: reference_fa_gdc_id
        source: reference_fa_gdc_id
      - id: reference_fai_gdc_id
        source: reference_fai_gdc_id
      - id: reference_pac_gdc_id
        source: reference_pac_gdc_id
      - id: reference_sa_gdc_id
        source: reference_sa_gdc_id
      - id: indexd_bam_uuid
        valueFrom: "NULL"
      - id: indexd_bai_uuid
        valueFrom: "NULL"
      - id: indexd_mirna_profiling_tar_uuid
        valueFrom: "NULL"
      - id: indexd_mirna_profiling_isoforms_quant_uuid
        valueFrom: "NULL"
      - id: indexd_mirna_profiling_mirnas_quant_uuid
        valueFrom: "NULL"
      - id: indexd_sqlite_uuid
        valueFrom: "NULL"
      - id: slurm_resource_cores
        source: slurm_resource_cores
      - id: slurm_resource_disk_gigabytes
        source: slurm_resource_disk_gigabytes
      - id: slurm_resource_mem_megabytes
        source: slurm_resource_mem_megabytes
      - id: status
        valueFrom: "RUNNING"
      - id: step_token
        source: bioclient_config
      - id: table_name
        source: status_table
      - id: task_uuid
        source: task_uuid
      - id: thread_count
        source: thread_count
    out:
      - id: token

  - id: etl
    run: etl.cwl
    in:
      - id: bioclient_config
        source: bioclient_config
      - id: bioclient_load_bucket
        source: bioclient_load_bucket
      - id: input_bam_gdc_id
        source: input_bam_gdc_id
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
      - id: reference_dict_gdc_id
        source: reference_dict_gdc_id
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
      - id: task_uuid
        source: task_uuid
    out:
      - id: indexd_bam_json
      - id: indexd_bai_json
      - id: indexd_mirna_profiling_tar_json
      - id: indexd_mirna_profiling_isoforms_quant_json
      - id: indexd_mirna_profiling_mirnas_quant_json
      - id: indexd_sqlite_json
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
        
  - id: emit_bai_uuid
    run: ../../tools/emit_json_value.cwl
    in:
      - id: input
        source: etl/indexd_bai_json
      - id: key
        valueFrom: did
    out:
      - id: output
        
  - id: emit_sqlite_uuid
    run: ../../tools/emit_json_value.cwl
    in:
      - id: input
        source: etl/indexd_sqlite_json
      - id: key
        valueFrom: did
    out:
      - id: output
        
  - id: emit_mirna_profiling_tar_uuid
    run: ../../tools/emit_json_value.cwl
    in:
      - id: input
        source: etl/indexd_mirna_profiling_tar_json
      - id: key
        valueFrom: did
    out:
      - id: output
        
  - id: emit_mirna_profiling_isoforms_quant_uuid
    run: ../../tools/emit_json_value.cwl
    in:
      - id: input
        source: etl/indexd_mirna_profiling_isoforms_quant_json
      - id: key
        valueFrom: did
    out:
      - id: output
        
  - id: emit_mirna_profiling_mirnas_quant_uuid
    run: ../../tools/emit_json_value.cwl
    in:
      - id: input
        source: etl/indexd_mirna_profiling_mirnas_quant_json
      - id: key
        valueFrom: did
    out:
      - id: output
        
  - id: status_complete
    run: status_postgres.cwl
    in:
      - id: cwl_workflow_git_hash
        source: cwl_workflow_git_hash
      - id: cwl_workflow_git_repo
        source: cwl_workflow_git_repo
      - id: cwl_workflow_rel_path
        source: cwl_workflow_rel_path
      - id: cwl_task_git_hash
        source: cwl_task_git_hash
      - id: cwl_task_git_repo
        source: cwl_task_git_repo
      - id: cwl_task_rel_path
        source: cwl_task_rel_path
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
      - id: reference_dict_gdc_id
        source: reference_dict_gdc_id
      - id: reference_fa_gdc_id
        source: reference_fa_gdc_id
      - id: reference_fai_gdc_id
        source: reference_fai_gdc_id
      - id: reference_pac_gdc_id
        source: reference_pac_gdc_id
      - id: reference_sa_gdc_id
        source: reference_sa_gdc_id
      - id: indexd_bam_uuid
        source: emit_bam_uuid/output
      - id: indexd_bai_uuid
        source: emit_bai_uuid/output
      - id: indexd_mirna_profiling_tar_uuid
        source: emit_mirna_profiling_tar_uuid/output
      - id: indexd_mirna_profiling_isoforms_quant_uuid
        source: emit_mirna_profiling_isoforms_quant_uuid/output
      - id: indexd_mirna_profiling_mirnas_quant_uuid
        source: emit_mirna_profiling_mirnas_quant_uuid/output
      - id: indexd_sqlite_uuid
        source: emit_sqlite_uuid/output
      - id: slurm_resource_cores
        source: slurm_resource_cores
      - id: slurm_resource_disk_gigabytes
        source: slurm_resource_disk_gigabytes
      - id: slurm_resource_mem_megabytes
        source: slurm_resource_mem_megabytes
      - id: status
        valueFrom: "COMPLETE"
      - id: step_token
        source: etl/token
      - id: table_name
        source: status_table
      - id: task_uuid
        source: task_uuid
      - id: thread_count
        source: thread_count
    out:
      - id: token
