cwlVersion: v1.0
class: Workflow
id: gdc_dnaseq_stage_data_wf
requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: SubworkflowFeatureRequirement
  - class: ScatterFeatureRequirement
  - class: SchemaDefRequirement
    types:
      - $import: ../../tools/readgroup.yml
      - $import: ../../tools/target_kit_schema.yml

inputs:
  bioclient_config: File
  readgroup_fastq_pe_uuid_list:
    type:
      type: array
      items: ../../tools/readgroup.yml#readgroup_fastq_uuid
  readgroup_fastq_se_uuid_list:
    type:
      type: array
      items: ../../tools/readgroup.yml#readgroup_fastq_uuid
  readgroup_bam_uuid_list:
    type:
      type: array
      items: ../../tools/readgroup.yml#readgroups_bam_uuid
  amplicon_kit_set_uuid_list:
    type:
      type: array
      items: ../../tools/target_kit_schema.yml#amplicon_kit_set_uuid
  capture_kit_set_uuid_list:
    type:
      type: array
      items: ../../tools/target_kit_schema.yml#capture_kit_set_uuid
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

outputs:
  rg_fastq_pe_files:
    type:
      type: array
      items: ../../tools/readgroup.yml#readgroup_fastq_file
    outputSource: extract_pe_fastqs/output

  rg_fastq_se_files:
    type:
      type: array
      items: ../../tools/readgroup.yml#readgroup_fastq_file
    outputSource: extract_se_fastqs/output

  rg_bam_files:
    type:
      type: array
      items: ../../tools/readgroup.yml#readgroups_bam_file
    outputSource: extract_bams/output

  amplicon_kit_files:
    type:
      type: array
      items: ../../tools/target_kit_schema.yml#amplicon_kit_set_file
    outputSource: extract_amplicon_kits/output

  capture_kit_files:
    type:
      type: array
      items: ../../tools/target_kit_schema.yml#capture_kit_set_file
    outputSource: extract_capture_kits/output

  reference_fasta:
    type: File
    outputSource: root_fasta_files/output

  common_biallelic_vcf: 
    type: File
    outputSource: root_common_biallelic_vcf_files/output

  known_snp_vcf: 
    type: File
    outputSource: root_known_snp_files/output

  sq_header_file:
    type: File
    outputSource: extract_sq_header/output

steps:
  extract_pe_fastqs:
    run: ./extract_readgroup_fastq_pe.cwl
    scatter: readgroup_fastq_pe_uuid
    in:
      readgroup_fastq_pe_uuid: readgroup_fastq_pe_uuid_list
      bioclient_config: bioclient_config
    out: [ output ]

  extract_se_fastqs:
    run: ./extract_readgroup_fastq_se.cwl
    scatter: readgroup_fastq_se_uuid
    in:
      readgroup_fastq_se_uuid: readgroup_fastq_se_uuid_list
      bioclient_config: bioclient_config
    out: [ output ]

  extract_bams:
    run: ./extract_readgroups_bam.cwl
    scatter: readgroups_bam_uuid
    in:
      readgroups_bam_uuid: readgroup_bam_uuid_list
      bioclient_config: bioclient_config
    out: [ output ]

  extract_amplicon_kits:
    run: ./extract_amplicon_kit.cwl
    scatter: amplicon_kit_set_uuid
    in:
      bioclient_config: bioclient_config
      amplicon_kit_set_uuid: amplicon_kit_set_uuid_list
    out: [ output ]

  extract_capture_kits:
    run: ./extract_capture_kit.cwl
    scatter: capture_kit_set_uuid
    in:
      bioclient_config: bioclient_config
      capture_kit_set_uuid: capture_kit_set_uuid_list
    out: [ output ]

  extract_common_biallelic_vcf:
    run: ../../tools/bio_client_download.cwl
    in:
      config-file: bioclient_config
      download_handle: common_biallelic_vcf_gdc_id
      file_size: common_biallelic_vcf_file_size
    out: [ output ]

  extract_common_biallelic_vcf_index:
    run: ../../tools/bio_client_download.cwl
    in:
      config-file: bioclient_config
      download_handle: common_biallelic_vcf_index_gdc_id
      file_size: common_biallelic_vcf_index_file_size
    out: [ output ]

  extract_known_snp:
    run: ../../tools/bio_client_download.cwl
    in:
      config-file: bioclient_config
      download_handle: known_snp_gdc_id
      file_size: known_snp_file_size
    out: [ output ]

  extract_known_snp_index:
    run: ../../tools/bio_client_download.cwl
    in:
      config-file: bioclient_config
      download_handle: known_snp_index_gdc_id
      file_size: known_snp_index_file_size
    out: [ output ]

  extract_reference_amb:
    run: ../../tools/bio_client_download.cwl
    in:
      config-file: bioclient_config
      download_handle: reference_amb_gdc_id
      file_size: reference_amb_file_size
    out: [ output ]

  extract_reference_ann:
    run: ../../tools/bio_client_download.cwl
    in:
      config-file: bioclient_config
      download_handle: reference_ann_gdc_id
      file_size: reference_ann_file_size
    out: [ output ]

  extract_reference_bwt:
    run: ../../tools/bio_client_download.cwl
    in:
      config-file: bioclient_config
      download_handle: reference_bwt_gdc_id
      file_size: reference_bwt_file_size
    out: [ output ]

  extract_reference_dict:
    run: ../../tools/bio_client_download.cwl
    in:
      config-file: bioclient_config
      download_handle: reference_dict_gdc_id
      file_size: reference_dict_file_size
    out: [ output ]

  extract_reference_fa:
    run: ../../tools/bio_client_download.cwl
    in:
      config-file: bioclient_config
      download_handle: reference_fa_gdc_id
      file_size: reference_fa_file_size
    out: [ output ]

  extract_reference_fai:
    run: ../../tools/bio_client_download.cwl
    in:
      config-file: bioclient_config
      download_handle: reference_fai_gdc_id
      file_size: reference_fai_file_size
    out: [ output ]

  extract_reference_pac:
    run: ../../tools/bio_client_download.cwl
    in:
      config-file: bioclient_config
      download_handle: reference_pac_gdc_id
      file_size: reference_pac_file_size
    out: [ output ]

  extract_reference_sa:
    run: ../../tools/bio_client_download.cwl
    in:
      config-file: bioclient_config
      download_handle: reference_sa_gdc_id
      file_size: reference_sa_file_size
    out: [ output ]

  extract_sq_header:
    run: ../../tools/bio_client_download.cwl
    in:
      config-file: bioclient_config
      download_handle: sq_header_gdc_id
      file_size: sq_header_file_size
    out: [ output ]

  root_fasta_files:
    run: ../../tools/root_fasta_dnaseq.cwl
    in:
      fasta: extract_reference_fa/output
      fasta_amb: extract_reference_amb/output
      fasta_ann: extract_reference_ann/output
      fasta_bwt: extract_reference_bwt/output
      fasta_dict: extract_reference_dict/output
      fasta_fai: extract_reference_fai/output
      fasta_pac: extract_reference_pac/output
      fasta_sa: extract_reference_sa/output
    out: [ output ]

  root_common_biallelic_vcf_files:
    run: ../../tools/root_vcf.cwl
    in:
      vcf: extract_common_biallelic_vcf/output
      vcf_index: extract_common_biallelic_vcf_index/output
    out: [ output ]

  root_known_snp_files:
    run: ../../tools/root_vcf.cwl
    in:
      vcf: extract_known_snp/output
      vcf_index: extract_known_snp_index/output
    out: [ output ]
