#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: MultipleInputFeatureRequirement
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  - id: bioclient_config
    type: File
  - id: bioclient_load_bucket
    type: string
  - id: input_bam_gdc_id
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
  - id: start_token
    type: File
  - id: thread_count
    type: long
  - id: task_uuid
    type: string

outputs:
  - id: indexd_bam_json
    type: string
    outputSource: emit_indexd_bam_json/output
  - id: indexd_bai_json
    type: string
    outputSource: emit_indexd_bai_json/output
  - id: indexd_mirna_profiling_tar_json
    type: string
    outputSource: emit_indexd_mirna_profiling_tar_json/output
  - id: indexd_mirna_profiling_isoforms_quant_json
    type: string
    outputSource: emit_indexd_mirna_profiling_isoforms_quant_json/output
  - id: indexd_mirna_profiling_mirnas_quant_json
    type: string
    outputSource: emit_indexd_mirna_profiling_mirnas_quant_json/output
  - id: indexd_sqlite_json
    type: string
    outputSource: emit_indexd_sqlite_json/output
  - id: token
    type: File
    outputSource: generate_token/token

steps:
  - id: extract_bam
    run: ../../tools/bio_client_download.cwl
    in:
      - id: config-file
        source: bioclient_config
      - id: download_handle
        source: input_bam_gdc_id
    out:
      - id: output

  - id: extract_known_snp
    run: ../../tools/bio_client_download.cwl
    in:
      - id: config-file
        source: bioclient_config
      - id: download_handle
        source: known_snp_gdc_id
    out:
      - id: output

  - id: extract_known_snp_index
    run: ../../tools/bio_client_download.cwl
    in:
      - id: config-file
        source: bioclient_config
      - id: download_handle
        source: known_snp_index_gdc_id
    out:
      - id: output

  - id: extract_ref_fa
    run: ../../tools/bio_client_download.cwl
    in:
      - id: config-file
        source: bioclient_config
      - id: download_handle
        source: reference_fa_gdc_id
    out:
      - id: output

  - id: extract_ref_fai
    run: ../../tools/bio_client_download.cwl
    in:
      - id: config-file
        source: bioclient_config
      - id: download_handle
        source: reference_fai_gdc_id
    out:
      - id: output

  - id: extract_ref_dict
    run: ../../tools/bio_client_download.cwl
    in:
      - id: config-file
        source: bioclient_config
      - id: download_handle
        source: reference_dict_gdc_id
    out:
      - id: output

  - id: extract_ref_amb
    run: ../../tools/bio_client_download.cwl
    in:
      - id: config-file
        source: bioclient_config
      - id: download_handle
        source: reference_amb_gdc_id
    out:
      - id: output

  - id: extract_ref_ann
    run: ../../tools/bio_client_download.cwl
    in:
      - id: config-file
        source: bioclient_config
      - id: download_handle
        source: reference_ann_gdc_id
    out:
      - id: output

  - id: extract_ref_bwt
    run: ../../tools/bio_client_download.cwl
    in:
      - id: config-file
        source: bioclient_config
      - id: download_handle
        source: reference_bwt_gdc_id
    out:
      - id: output

  - id: extract_ref_pac
    run: ../../tools/bio_client_download.cwl
    in:
      - id: config-file
        source: bioclient_config
      - id: download_handle
        source: reference_pac_gdc_id
    out:
      - id: output

  - id: extract_ref_sa
    run: ../../tools/bio_client_download.cwl
    in:
      - id: config-file
        source: bioclient_config
      - id: download_handle
        source: reference_sa_gdc_id
    out:
      - id: output

  - id: root_fasta_files
    run: ../../tools/root_fasta_dnaseq.cwl
    in:
      - id: fasta
        source: extract_ref_fa/output
      - id: fasta_amb
        source: extract_ref_amb/output
      - id: fasta_ann
        source: extract_ref_ann/output
      - id: fasta_bwt
        source: extract_ref_bwt/output
      - id: fasta_dict
        source: extract_ref_dict/output
      - id: fasta_fai
        source: extract_ref_fai/output
      - id: fasta_pac
        source: extract_ref_pac/output
      - id: fasta_sa
        source: extract_ref_sa/output
    out:
      - id: output

  - id: root_known_snp_files
    run: ../../tools/root_vcf.cwl
    in:
      - id: vcf
        source: extract_known_snp/output
      - id: vcf_index
        source: extract_known_snp_index/output
    out:
      - id: output
 
  - id: transform
    run: transform_mirna.cwl
    in:
      - id: input_bam
        source: extract_bam/output
      - id: known_snp
        source: root_known_snp_files/output
      - id: reference_sequence
        source: root_fasta_files/output
      - id: thread_count
        source: thread_count
      - id: task_uuid
        source: task_uuid
    out:
      - id: merge_all_sqlite_destination_sqlite
      - id: mirna_profiling_mirna_adapter_report_sorted_output
      - id: mirna_profiling_mirna_alignment_stats_features
      - id: mirna_profiling_mirna_expression_matrix_expn_matrix_txt
      - id: mirna_profiling_mirna_expression_matrix_expn_matrix_norm_txt
      - id: mirna_profiling_mirna_expression_matrix_expn_matrix_norm_log_txt
      - id: mirna_profiling_mirna_expression_matrix_mimat_expn_matrix_mimat_txt
      - id: mirna_profiling_mirna_expression_matrix_mimat_expn_matrix_mimat_norm_txt
      - id: mirna_profiling_mirna_expression_matrix_mimat_expn_matrix_mimat_norm_log_txt
      - id: mirna_profiling_mirna_graph_libs_jpgs
      - id: mirna_profiling_mirna_tcga_isoforms_quant
      - id: mirna_profiling_mirna_tcga_mirnas_quant
      - id: picard_markduplicates_output

  - id: tar_mirna_profiling_alignment_stats
    run: ../../tools/tar_dir.cwl
    in:
      - id: INPUT
        source: transform/mirna_profiling_mirna_alignment_stats_features
      - id: file
        valueFrom: features.tar
    out:
      - id: OUTPUT

  - id: tar_mirna_profiling_graph_libs
    run: ../../tools/tar_dir.cwl
    in:
      - id: INPUT
        source: transform/mirna_profiling_mirna_graph_libs_jpgs
      - id: file
        valueFrom: graph_libs_jpgs.tar
    out:
      - id: OUTPUT

  - id: tar_mirna_profiling
    run: ../../tools/tar.cwl
    in:
      - id: INPUT
        source: [
          transform/mirna_profiling_mirna_adapter_report_sorted_output,
          tar_mirna_profiling_alignment_stats/OUTPUT,
          tar_mirna_profiling_graph_libs/OUTPUT,
          transform/mirna_profiling_mirna_expression_matrix_expn_matrix_txt,
          transform/mirna_profiling_mirna_expression_matrix_expn_matrix_norm_txt,
          transform/mirna_profiling_mirna_expression_matrix_expn_matrix_norm_log_txt,
          transform/mirna_profiling_mirna_expression_matrix_mimat_expn_matrix_mimat_txt,
          transform/mirna_profiling_mirna_expression_matrix_mimat_expn_matrix_mimat_norm_txt,
          transform/mirna_profiling_mirna_expression_matrix_mimat_expn_matrix_mimat_norm_log_txt,
          transform/mirna_profiling_mirna_tcga_isoforms_quant,
          transform/mirna_profiling_mirna_tcga_mirnas_quant
        ]
      - id: file
        source: task_uuid
        valueFrom: $(self)_mirna_profiling.tar.xz
    out:
      - id: OUTPUT

  - id: rename_isoforms_quant
    run: ../../tools/rename.cwl
    in:
      - id: INPUT
        source: transform/mirna_profiling_mirna_tcga_isoforms_quant
      - id: OUTNAME
        source: input_bam_gdc_id
        valueFrom: $(self).mirbase21.isoforms.quantification.txt
    out:
      - id: OUTPUT

  - id: rename_mirnas_quant
    run: ../../tools/rename.cwl
    in:
      - id: INPUT
        source: transform/mirna_profiling_mirna_tcga_mirnas_quant
      - id: OUTNAME
        source: input_bam_gdc_id
        valueFrom: $(self).mirbase21.mirnas.quantification.txt
    out:
      - id: OUTPUT

  - id: load_bam
    run: ../../tools/bio_client_upload_pull_uuid.cwl
    in:
      - id: config-file
        source: bioclient_config
      - id: input
        source: transform/picard_markduplicates_output
      - id: upload-bucket
        source: bioclient_load_bucket
        valueFrom: $(self + "/" + inputs.task_uuid + "/")
      - id: task_uuid
        source: task_uuid
        valueFrom: $(null)
    out:
      - id: output

  - id: load_bai
    run: ../../tools/bio_client_upload_pull_uuid.cwl
    in:
      - id: config-file
        source: bioclient_config
      - id: input
        source: transform/picard_markduplicates_output
        valueFrom: $(self.secondaryFiles[0])
      - id: upload-bucket
        source: bioclient_load_bucket
        valueFrom: $(self + "/" + inputs.task_uuid + "/")
      - id: task_uuid
        source: task_uuid
        valueFrom: $(null)
    out:
      - id: output

  - id: load_sqlite
    run: ../../tools/bio_client_upload_pull_uuid.cwl
    in:
      - id: config-file
        source: bioclient_config
      - id: input
        source: transform/merge_all_sqlite_destination_sqlite
      - id: upload-bucket
        source: bioclient_load_bucket
        valueFrom: $(self + "/" + inputs.task_uuid + "/")
      - id: task_uuid
        source: task_uuid
        valueFrom: $(null)
    out:
      - id: output

  - id: load_tar_mirna_profiling
    run: ../../tools/bio_client_upload_pull_uuid.cwl
    in:
      - id: config-file
        source: bioclient_config
      - id: input
        source: tar_mirna_profiling/OUTPUT
      - id: upload-bucket
        source: bioclient_load_bucket
        valueFrom: $(self + "/" + inputs.task_uuid + "/")
      - id: task_uuid
        source: task_uuid
        valueFrom: $(null)
    out:
      - id: output

  - id: load_mirna_profiling_isoforms_quant
    run: ../../tools/bio_client_upload_pull_uuid.cwl
    in:
      - id: config-file
        source: bioclient_config
      - id: input
        source: rename_isoforms_quant/OUTPUT
      - id: upload-bucket
        source: bioclient_load_bucket
        valueFrom: $(self + "/" + inputs.task_uuid + "/")
      - id: task_uuid
        source: task_uuid
        valueFrom: $(null)
    out:
      - id: output

  - id: load_mirna_profiling_mirnas_quant
    run: ../../tools/bio_client_upload_pull_uuid.cwl
    in:
      - id: config-file
        source: bioclient_config
      - id: input
        source: rename_mirnas_quant/OUTPUT
      - id: upload-bucket
        source: bioclient_load_bucket
        valueFrom: $(self + "/" + inputs.task_uuid + "/")
      - id: task_uuid
        source: task_uuid
        valueFrom: $(null)
    out:
      - id: output

  - id: emit_indexd_bam_json
    run: ../../tools/json_file_to_string.cwl
    in:
      - id: input
        source: load_bam/output
    out:
      - id: output

  - id: emit_indexd_bai_json
    run: ../../tools/json_file_to_string.cwl
    in:
      - id: input
        source: load_bai/output
    out:
      - id: output

  - id: emit_indexd_mirna_profiling_tar_json
    run: ../../tools/json_file_to_string.cwl
    in:
      - id: input
        source: load_tar_mirna_profiling/output
    out:
      - id: output

  - id: emit_indexd_mirna_profiling_isoforms_quant_json
    run: ../../tools/json_file_to_string.cwl
    in:
      - id: input
        source: load_mirna_profiling_isoforms_quant/output
    out:
      - id: output

  - id: emit_indexd_mirna_profiling_mirnas_quant_json
    run: ../../tools/json_file_to_string.cwl
    in:
      - id: input
        source: load_mirna_profiling_mirnas_quant/output
    out:
      - id: output

  - id: emit_indexd_sqlite_json
    run: ../../tools/json_file_to_string.cwl
    in:
      - id: input
        source: load_sqlite/output
    out:
      - id: output

  - id: generate_token
    run: ../../tools/generate_load_token.cwl
    in:
      - id: load1
        source: load_bam/output
      - id: load2
        source: load_bai/output
      - id: load3
        source: load_mirna_profiling_isoforms_quant/output
      - id: load4
        source: load_mirna_profiling_mirnas_quant/output
      - id: load5
        source: load_tar_mirna_profiling/output
      - id: load6
        source: load_sqlite/output
    out:
      - id: token
