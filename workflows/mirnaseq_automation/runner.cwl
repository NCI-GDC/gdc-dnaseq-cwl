#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: SchemaDefRequirement
    types:
      - $import: ../../tools/readgroup.yml
      - $import: ../../tools/capture_kit.yml
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
  - id: job_uuid
    type: string
  - id: capture_kit_set_list
    type:
      type: array
      items: ../../tools/capture_kit.yml#capture_kit_set
  - id: readgroup_fastq_pe_uuid_list
    type:
      type: array
      items:  ../../tools/readgroup.yml#readgroup_fastq_pe_uuid
  - id: readgroup_fastq_se_uuid_list
    type:
      type: array
      items:  ../../tools/readgroup.yml#readgroup_fastq_se_uuid
  - id: readgroups_bam_uuid_list
    type: 
      type: array
      items: ../../tools/readgroup.yml#readgroups_bam_uuid
  - id: slurm_resource_cores
    type: long
  - id: slurm_resource_disk_gigabytes
    type: long
  - id: slurm_resource_mem_megabytes
    type: long
  - id: status_table
    type: string
  - id: known_snp_gdc_id
    type: string
  - id: known_snp_file_size
    type: long
  - id: known_snp_index_gdc_id
    type: string
  - id: known_snp_index_file_size
    type: long
  - id: reference_amb_gdc_id
    type: string
  - id: reference_amb_file_size
    type: long
  - id: reference_ann_gdc_id
    type: string
  - id: reference_ann_file_size
    type: long
  - id: reference_bwt_gdc_id
    type: string
  - id: reference_bwt_file_size
    type: long
  - id: reference_dict_gdc_id
    type: string
  - id: reference_dict_file_size
    type: long
  - id: reference_fa_gdc_id
    type: string
  - id: reference_fa_file_size
    type: long
  - id: reference_fai_gdc_id
    type: string
  - id: reference_fai_file_size
    type: long
  - id: reference_pac_gdc_id
    type: string
  - id: reference_pac_file_size
    type: long
  - id: reference_sa_gdc_id
    type: string
  - id: reference_sa_file_size
    type: long
  - id: thread_count
    type: long

outputs:
  - id: indexd_bam_uuid
    type: string
    outputSource: emit_bam_uuid/output
  - id: indexd_bai_uuid
    type: string
    outputSource: emit_bai_uuid/output
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
      - id: cwl_job_git_hash
        source: cwl_job_git_hash
      - id: cwl_job_git_repo
        source: cwl_job_git_repo
      - id: cwl_job_rel_path
        source: cwl_job_rel_path
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
      - id: indexd_bam_uuid
        valueFrom: "NULL"
      - id: indexd_bai_uuid
        valueFrom: "NULL"
      - id: indexd_sqlite_uuid
        valueFrom: "NULL"
      # - id: readgroup_fastq_pe_uuid_list
      #   source: readgroup_fastq_pe_uuid_list
      # - id: readgroup_fastq_se_uuid_list
      #   source: readgroup_fastq_se_uuid_list
      # - id: readgroups_bam_uuid_list
      #   source: readgroups_bam_uuid_list
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
      - id: status_table
        source: status_table
      - id: job_uuid
        source: job_uuid
      - id: known_snp_gdc_id
        source: known_snp_gdc_id
      - id: known_snp_file_size
        source: known_snp_file_size
      - id: known_snp_index_gdc_id
        source: known_snp_index_gdc_id
      - id: known_snp_index_file_size
        source: known_snp_index_file_size
      - id: reference_amb_gdc_id
        source: reference_amb_gdc_id
      - id: reference_amb_file_size
        source: reference_amb_file_size
      - id: reference_ann_gdc_id
        source: reference_ann_gdc_id
      - id: reference_ann_file_size
        source: reference_ann_file_size
      - id: reference_bwt_gdc_id
        source: reference_bwt_gdc_id
      - id: reference_bwt_file_size
        source: reference_bwt_file_size
      - id: reference_dict_gdc_id
        source: reference_dict_gdc_id
      - id: reference_dict_file_size
        source: reference_dict_file_size
      - id: reference_fa_gdc_id
        source: reference_fa_gdc_id
      - id: reference_fa_file_size
        source: reference_fa_file_size
      - id: reference_fai_gdc_id
        source: reference_fai_gdc_id
      - id: reference_fai_file_size
        source: reference_fai_file_size
      - id: reference_pac_gdc_id
        source: reference_pac_gdc_id
      - id: reference_pac_file_size
        source: reference_pac_file_size
      - id: reference_sa_gdc_id
        source: reference_sa_gdc_id
      - id: reference_sa_file_size
        source: reference_sa_file_size
      - id: thread_count
        source: thread_count
    out:
      - id: token

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
      - id: capture_kit_set_list
        source: capture_kit_set_list
      - id: readgroup_fastq_pe_uuid_list
        source: readgroup_fastq_pe_uuid_list
      - id: readgroup_fastq_se_uuid_list
        source: readgroup_fastq_se_uuid_list
      - id: readgroups_bam_uuid_list
        source: readgroups_bam_uuid_list
      - id: start_token
        source: status_running/token
      - id: known_snp_gdc_id
        source: known_snp_gdc_id
      - id: known_snp_file_size
        source: known_snp_file_size
      - id: known_snp_index_gdc_id
        source: known_snp_index_gdc_id
      - id: known_snp_index_file_size
        source: known_snp_index_file_size
      - id: reference_amb_gdc_id
        source: reference_amb_gdc_id
      - id: reference_amb_file_size
        source: reference_amb_file_size
      - id: reference_ann_gdc_id
        source: reference_ann_gdc_id
      - id: reference_ann_file_size
        source: reference_ann_file_size
      - id: reference_bwt_gdc_id
        source: reference_bwt_gdc_id
      - id: reference_bwt_file_size
        source: reference_bwt_file_size
      - id: reference_dict_gdc_id
        source: reference_dict_gdc_id
      - id: reference_dict_file_size
        source: reference_dict_file_size
      - id: reference_fa_gdc_id
        source: reference_fa_gdc_id
      - id: reference_fa_file_size
        source: reference_fa_file_size
      - id: reference_fai_gdc_id
        source: reference_fai_gdc_id
      - id: reference_fai_file_size
        source: reference_fai_file_size
      - id: reference_pac_gdc_id
        source: reference_pac_gdc_id
      - id: reference_pac_file_size
        source: reference_pac_file_size
      - id: reference_sa_gdc_id
        source: reference_sa_gdc_id
      - id: reference_sa_file_size
        source: reference_sa_file_size
      - id: thread_count
        source: thread_count
    out:
      - id: indexd_bam_json
      - id: indexd_bai_json
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

  - id: status_complete
    run: status_postgres.cwl
    in:
      - id: cwl_workflow_git_hash
        source: cwl_workflow_git_hash
      - id: cwl_workflow_git_repo
        source: cwl_workflow_git_repo
      - id: cwl_workflow_rel_path
        source: cwl_workflow_rel_path
      - id: cwl_job_git_hash
        source: cwl_job_git_hash
      - id: cwl_job_git_repo
        source: cwl_job_git_repo
      - id: cwl_job_rel_path
        source: cwl_job_rel_path
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
      - id: indexd_bam_uuid
        source: emit_bam_uuid/output
      - id: indexd_bai_uuid
        source: emit_bai_uuid/output
      - id: indexd_sqlite_uuid
        valueFrom: emit_sqlite_uuid/output
      # - id: readgroup_fastq_pe_uuid_list
      #   source: readgroup_fastq_pe_uuid_list
      # - id: readgroup_fastq_se_uuid_list
      #   source: readgroup_fastq_se_uuid_list
      # - id: readgroups_bam_uuid_list
      #   source: readgroups_bam_uuid_list
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
      - id: status_table
        source: status_table
      - id: job_uuid
        source: job_uuid
      - id: known_snp_gdc_id
        source: known_snp_gdc_id
      - id: known_snp_file_size
        source: known_snp_file_size
      - id: known_snp_index_gdc_id
        source: known_snp_index_gdc_id
      - id: known_snp_index_file_size
        source: known_snp_index_file_size
      - id: reference_amb_gdc_id
        source: reference_amb_gdc_id
      - id: reference_amb_file_size
        source: reference_amb_file_size
      - id: reference_ann_gdc_id
        source: reference_ann_gdc_id
      - id: reference_ann_file_size
        source: reference_ann_file_size
      - id: reference_bwt_gdc_id
        source: reference_bwt_gdc_id
      - id: reference_bwt_file_size
        source: reference_bwt_file_size
      - id: reference_dict_gdc_id
        source: reference_dict_gdc_id
      - id: reference_dict_file_size
        source: reference_dict_file_size
      - id: reference_fa_gdc_id
        source: reference_fa_gdc_id
      - id: reference_fa_file_size
        source: reference_fa_file_size
      - id: reference_fai_gdc_id
        source: reference_fai_gdc_id
      - id: reference_fai_file_size
        source: reference_fai_file_size
      - id: reference_pac_gdc_id
        source: reference_pac_gdc_id
      - id: reference_pac_file_size
        source: reference_pac_file_size
      - id: reference_sa_gdc_id
        source: reference_sa_gdc_id
      - id: reference_sa_file_size
        source: reference_sa_file_size
      - id: thread_count
        source: thread_count
    out:
      - id: token
