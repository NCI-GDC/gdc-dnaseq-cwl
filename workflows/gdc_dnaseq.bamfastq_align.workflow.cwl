#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: ScatterFeatureRequirement
  - class: SchemaDefRequirement
    types:
      - $import: ../tools/amplicon_kit.yml
      - $import: ../tools/capture_kit.yml
      - $import: ../tools/readgroup.yml
  - class: StepInputExpressionRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  bam_name: string
  bioclient_config: File
  bioclient_load_bucket: string
  job_uuid: string
  amplicon_kit_set_uuid_list:
    type:
      type: array
      items: ../tools/amplicon_kit.yml#amplicon_kit_set_uuid
  capture_kit_set_uuid_list:
    type:
      type: array
      items: ../tools/capture_kit.yml#capture_kit_set_uuid
  readgroup_fastq_pe_uuid_list:
    type:
      type: array
      items: ../tools/readgroup.yml#readgroup_fastq_pe_uuid
  readgroup_fastq_se_uuid_list:
    type:
      type: array
      items: ../tools/readgroup.yml#readgroup_fastq_se_uuid
  readgroups_bam_uuid_list:
    type: 
      type: array
      items: ../tools/readgroup.yml#readgroups_bam_uuid
  start_token: File?
  common_biallelic_vcf_gdc_id: string
  common_biallelic_vcf_file_size: long
  common_biallelic_vcf_index_gdc_id: string
  common_biallelic_vcf_index_file_size: long
  known_snp_gdc_id: string
  known_snp_file_size: long
  known_snp_index_gdc_id: string
  known_snp_index_file_size: long
  reference_amb_gdc_id: string
  reference_amb_file_size: long
  reference_ann_gdc_id: string
  reference_ann_file_size: long
  reference_bwt_gdc_id: string
  reference_bwt_file_size: long
  reference_dict_gdc_id: string
  reference_dict_file_size: long
  reference_fa_gdc_id: string
  reference_fa_file_size: long
  reference_fai_gdc_id: string
  reference_fai_file_size: long
  reference_pac_gdc_id: string
  reference_pac_file_size: long
  reference_sa_gdc_id: string
  reference_sa_file_size: long
  sq_header_gdc_id: string
  sq_header_file_size: long
  run_bamindex: long[]
  run_markduplicates: long[]
  thread_count: long

outputs:
  indexd_bam_uuid:
    type: string
    outputSource: emit_bam_uuid/output
  indexd_bai_uuid:
    type: string
    outputSource: emit_bai_uuid/output
  indexd_sqlite_uuid:
    type: string
    outputSource: emit_sqlite_uuid/output

steps:
  extract_stage_files:
    run: ./extract/stage_data_workflow.cwl
    in:
      bioclient_config: bioclient_config
      readgroup_bam_uuid_list: readgroups_bam_uuid_list
      readgroup_fastq_pe_uuid_list: readgroup_fastq_pe_uuid_list
      readgroup_fastq_se_uuid_list: readgroup_fastq_se_uuid_list
      amplicon_kit_set_uuid_list: amplicon_kit_set_uuid_list
      capture_kit_set_uuid_list: capture_kit_set_uuid_list
      common_biallelic_vcf_gdc_id: common_biallelic_vcf_gdc_id 
      common_biallelic_vcf_file_size: common_biallelic_vcf_file_size 
      common_biallelic_vcf_index_gdc_id: common_biallelic_vcf_index_gdc_id 
      common_biallelic_vcf_index_file_size: common_biallelic_vcf_index_file_size
      known_snp_gdc_id: known_snp_gdc_id 
      known_snp_file_size: known_snp_file_size 
      known_snp_index_gdc_id: known_snp_index_gdc_id 
      known_snp_index_file_size: known_snp_index_file_size
      reference_amb_gdc_id: reference_amb_gdc_id 
      reference_amb_file_size: reference_amb_file_size
      reference_ann_gdc_id: reference_ann_gdc_id 
      reference_ann_file_size: reference_ann_file_size
      reference_bwt_gdc_id: reference_bwt_gdc_id 
      reference_bwt_file_size: reference_bwt_file_size 
      reference_dict_gdc_id: reference_dict_gdc_id 
      reference_dict_file_size: reference_dict_file_size 
      reference_fa_gdc_id: reference_fa_gdc_id 
      reference_fa_file_size: reference_fa_file_size 
      reference_fai_gdc_id: reference_fai_gdc_id 
      reference_fai_file_size: reference_fai_file_size 
      reference_pac_gdc_id: reference_pac_gdc_id 
      reference_pac_file_size: reference_pac_file_size 
      reference_sa_gdc_id: reference_sa_gdc_id 
      reference_sa_file_size: reference_sa_file_size 
      sq_header_gdc_id: sq_header_gdc_id 
      sq_header_file_size: sq_header_file_size 
    out: [ rg_fastq_pe_files, rg_fastq_se_files, rg_bam_files, amplicon_kit_files,
           capture_kit_files, reference_fasta, common_biallelic_vcf, known_snp_vcf,
           sq_header_file ]

  transform:
    run: ./transform/main_bamfastq_transform.cwl
    in:
      bam_name: bam_name
      job_uuid: job_uuid
      amplicon_kit_set_file_list: extract_stage_files/amplicon_kit_files
      capture_kit_set_file_list: extract_stage_files/capture_kit_files
      readgroup_fastq_pe_file_list: extract_stage_files/rg_fastq_pe_files
      readgroup_fastq_se_file_list: extract_stage_files/rg_fastq_se_files
      readgroups_bam_file_list: extract_stage_files/rg_bam_files
      common_biallelic_vcf: extract_stage_files/common_biallelic_vcf
      known_snp: extract_stage_files/known_snp_vcf
      reference_sequence: extract_stage_files/reference_fasta
      run_bamindex: run_bamindex
      run_markduplicates: run_markduplicates
      sq_header: extract_stage_files/sq_header_file 
      thread_count: thread_count
    out: [ output_bam, sqlite ]

  load_bam:
    run: ../tools/bio_client_upload_pull_uuid.cwl
    in:
      config-file: bioclient_config
      input: transform/output_bam
      upload-bucket: bioclient_load_bucket
      upload-key:
        valueFrom: $(inputs.job_uuid)/$(inputs.input.basename)
      job_uuid:
        source: job_uuid
        valueFrom: $(null)
    out: [ output ]

  load_bai:
    run: ../tools/bio_client_upload_pull_uuid.cwl
    in:
      config-file: bioclient_config
      input:
        source: transform/output_bam
        valueFrom: $(self.secondaryFiles[0])
      upload-bucket: bioclient_load_bucket
      upload-key:
        valueFrom: $(inputs.job_uuid)/$(inputs.input.nameroot).bai
      job_uuid:
        source: job_uuid
        valueFrom: $(null)
    out: [ output ]

  load_sqlite:
    run: ../tools/bio_client_upload_pull_uuid.cwl
    in:
      config-file: bioclient_config
      input: transform/sqlite
      upload-bucket: bioclient_load_bucket
      upload-key:
        valueFrom: $(inputs.job_uuid)/$(inputs.input.basename)
      job_uuid:
        source: job_uuid
        valueFrom: $(null)
    out: [ output ]

  emit_bam_uuid:
    run: ../tools/emit_json_value.cwl
    in:
      input: load_bam/output
      key:
        valueFrom: did
    out: [ output ]

  emit_bai_uuid:
    run: ../tools/emit_json_value.cwl
    in:
      input: load_bai/output
      key:
        valueFrom: did
    out: [ output ]

  emit_sqlite_uuid:
    run: ../tools/emit_json_value.cwl
    in:
      input: load_sqlite/output
      key:
        valueFrom: did
    out: [ output ]
