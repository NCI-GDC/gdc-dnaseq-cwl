#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: MultipleInputFeatureRequirement
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  - id: gdc_token
    type: File
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

  - id: aws_config
    type: File
  - id: aws_shared_credentials
    type: File
  - id: endpoint_json
    type: File
  - id: load_bucket
    type: string
  - id: s3cfg_section
    type: string

outputs:
  - id: s3_bam_url
    type: string
    outputSource: generate_s3_bam_url/output
  - id: s3_bai_url
    type: string
    outputSource: generate_s3_bai_url/output
  - id: s3_mirna_profiling_tar_url
    type: string
    outputSource: generate_s3_mirna_profiling_tar_url/output
  - id: s3_mirna_profiling_isoforms_quant_url
    type: string
    outputSource: generate_s3_mirna_profiling_isoforms_quant_url/output
  - id: s3_mirna_profiling_mirnas_quant_url
    type: string
    outputSource: generate_s3_mirna_profiling_mirnas_quant_url/output
  - id: s3_sqlite_url
    type: string
    outputSource: generate_s3_sqlite_url/output
  - id: token
    type: File
    outputSource: generate_token/token

steps:
  - id: extract_bam
    run: ../../tools/gdc_get_object.cwl
    in:
      - id: gdc_token
        source: gdc_token
      - id: gdc_uuid
        source: input_bam_gdc_id
    out:
      - id: output

  - id: extract_known_snp
    run: ../../tools/gdc_get_object.cwl
    in:
      - id: gdc_token
        source: gdc_token
      - id: gdc_uuid
        source: known_snp_gdc_id
    out:
      - id: output

  - id: extract_known_snp_index
    run: ../../tools/gdc_get_object.cwl
    in:
      - id: gdc_token
        source: gdc_token
      - id: gdc_uuid
        source: known_snp_index_gdc_id
    out:
      - id: output

  - id: extract_ref_fa
    run: ../../tools/gdc_get_object.cwl
    in:
      - id: gdc_token
        source: gdc_token
      - id: gdc_uuid
        source: reference_fa_gdc_id
    out:
      - id: output

  - id: extract_ref_fai
    run: ../../tools/gdc_get_object.cwl
    in:
      - id: gdc_token
        source: gdc_token
      - id: gdc_uuid
        source: reference_fai_gdc_id
    out:
      - id: output

  - id: extract_ref_dict
    run: ../../tools/gdc_get_object.cwl
    in:
      - id: gdc_token
        source: gdc_token
      - id: gdc_uuid
        source: reference_dict_gdc_id
    out:
      - id: output

  - id: extract_ref_amb
    run: ../../tools/gdc_get_object.cwl
    in:
      - id: gdc_token
        source: gdc_token
      - id: gdc_uuid
        source: reference_amb_gdc_id
    out:
      - id: output

  - id: extract_ref_ann
    run: ../../tools/gdc_get_object.cwl
    in:
      - id: gdc_token
        source: gdc_token
      - id: gdc_uuid
        source: reference_ann_gdc_id
    out:
      - id: output

  - id: extract_ref_bwt
    run: ../../tools/gdc_get_object.cwl
    in:
      - id: gdc_token
        source: gdc_token
      - id: gdc_uuid
        source: reference_bwt_gdc_id
    out:
      - id: output

  - id: extract_ref_pac
    run: ../../tools/gdc_get_object.cwl
    in:
      - id: gdc_token
        source: gdc_token
      - id: gdc_uuid
        source: reference_pac_gdc_id
    out:
      - id: output

  - id: extract_ref_sa
    run: ../../tools/gdc_get_object.cwl
    in:
      - id: gdc_token
        source: gdc_token
      - id: gdc_uuid
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
      # - id: mirna_profiling_mirna_alignment_stats_alignment_stats_csv
      # - id: mirna_profiling_mirna_alignment_stats_3_UTR_txt
      # - id: mirna_profiling_mirna_alignment_stats_5_UTR_txt
      # - id: mirna_profiling_mirna_alignment_stats_Coding_Exon_txt
      # - id: mirna_profiling_mirna_alignment_stats_Intron_txt
      # - id: mirna_profiling_mirna_alignment_stats_LINE_txt
      # - id: mirna_profiling_mirna_alignment_stats_LTR_txt
      # - id: mirna_profiling_mirna_alignment_stats_SINE_txt
      # - id: mirna_profiling_mirna_alignment_stats_bed
      # - id: mirna_profiling_mirna_alignment_stats_chastity_taglengths_csv
      # - id: mirna_profiling_mirna_alignment_stats_crossmapped_txt
      # - id: mirna_profiling_mirna_alignment_stats_filtered_taglengths_csv
      # - id: mirna_profiling_mirna_alignment_stats_isoforms_txt
      # - id: mirna_profiling_mirna_alignment_stats_miRNA_txt
      # - id: mirna_profiling_mirna_alignment_stats_mirna_species_txt
      # - id: mirna_profiling_mirna_alignment_stats_rmsk_DNA_txt
      # - id: mirna_profiling_mirna_alignment_stats_rmsk_RNA_txt
      # - id: mirna_profiling_mirna_alignment_stats_rmsk_Simple_repeat_txt
      # - id: mirna_profiling_mirna_alignment_stats_rmsk_Unknown_txt
      # - id: mirna_profiling_mirna_alignment_stats_rRNA_txt
      # - id: mirna_profiling_mirna_alignment_stats_scRNA_txt
      # - id: mirna_profiling_mirna_alignment_stats_snoRNA_txt
      # - id: mirna_profiling_mirna_alignment_stats_snRNA_txt
      # - id: mirna_profiling_mirna_alignment_stats_softclip_taglengths_csv
      # - id: mirna_profiling_mirna_alignment_stats_srpRNA_txt
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
  #         transform/mirna_profiling_mirna_alignment_stats_alignment_stats_csv,
  #         transform/mirna_profiling_mirna_alignment_stats_3_UTR_txt,
  #         transform/mirna_profiling_mirna_alignment_stats_5_UTR_txt,
  #         transform/mirna_profiling_mirna_alignment_stats_Coding_Exon_txt,
  #         transform/mirna_profiling_mirna_alignment_stats_Intron_txt,
  #         transform/mirna_profiling_mirna_alignment_stats_LINE_txt,
  #         transform/mirna_profiling_mirna_alignment_stats_LTR_txt,
  #         transform/mirna_profiling_mirna_alignment_stats_SINE_txt,
  #         tar_mirna_profiling_bed/OUTPUT,
  #         transform/mirna_profiling_mirna_alignment_stats_chastity_taglengths_csv,
  #         transform/mirna_profiling_mirna_alignment_stats_crossmapped_txt,
  #         transform/mirna_profiling_mirna_alignment_stats_filtered_taglengths_csv,
  #         transform/mirna_profiling_mirna_alignment_stats_isoforms_txt,
  #         transform/mirna_profiling_mirna_alignment_stats_miRNA_txt,
  #         transform/mirna_profiling_mirna_alignment_stats_mirna_species_txt,
  #         transform/mirna_profiling_mirna_alignment_stats_rmsk_DNA_txt,
  #         transform/mirna_profiling_mirna_alignment_stats_rmsk_RNA_txt,
  #         transform/mirna_profiling_mirna_alignment_stats_rmsk_Simple_repeat_txt,
  #         transform/mirna_profiling_mirna_alignment_stats_rmsk_Unknown_txt,
  #         transform/mirna_profiling_mirna_alignment_stats_rRNA_txt,
  #         transform/mirna_profiling_mirna_alignment_stats_scRNA_txt,
  #         transform/mirna_profiling_mirna_alignment_stats_snoRNA_txt,
  #         transform/mirna_profiling_mirna_alignment_stats_snRNA_txt,
  #         transform/mirna_profiling_mirna_alignment_stats_softclip_taglengths_csv,
  #         transform/mirna_profiling_mirna_alignment_stats_srpRNA_txt,
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
    run: ../../tools/aws_s3_put.cwl
    in:
      - id: aws_config
        source: aws_config
      - id: aws_shared_credentials
        source: aws_shared_credentials
      - id: endpoint_json
        source: endpoint_json
      - id: input
        source: transform/picard_markduplicates_output
      - id: s3cfg_section
        source: s3cfg_section
      - id: s3uri
        source: load_bucket
        valueFrom: $(self + "/" + inputs.task_uuid + "/")
      - id: task_uuid
        source: task_uuid
        valueFrom: $(null)
    out:
      - id: output

  - id: load_bai
    run: ../../tools/aws_s3_put.cwl
    in:
      - id: aws_config
        source: aws_config
      - id: aws_shared_credentials
        source: aws_shared_credentials
      - id: endpoint_json
        source: endpoint_json
      - id: input
        source: transform/picard_markduplicates_output
        valueFrom: $(self.secondaryFiles[0])
      - id: s3cfg_section
        source: s3cfg_section
      - id: s3uri
        source: load_bucket
        valueFrom: $(self + "/" + inputs.task_uuid + "/")
      - id: task_uuid
        source: task_uuid
        valueFrom: $(null)
    out:
      - id: output

  - id: load_sqlite
    run: ../../tools/aws_s3_put.cwl
    in:
      - id: aws_config
        source: aws_config
      - id: aws_shared_credentials
        source: aws_shared_credentials
      - id: endpoint_json
        source: endpoint_json
      - id: input
        source: transform/merge_all_sqlite_destination_sqlite
      - id: s3cfg_section
        source: s3cfg_section
      - id: s3uri
        source: load_bucket
        valueFrom: $(self + "/" + inputs.task_uuid + "/")
      - id: task_uuid
        source: task_uuid
        valueFrom: $(null)
    out:
      - id: output

  - id: load_tar_mirna_profiling
    run: ../../tools/aws_s3_put.cwl
    in:
      - id: aws_config
        source: aws_config
      - id: aws_shared_credentials
        source: aws_shared_credentials
      - id: endpoint_json
        source: endpoint_json
      - id: input
        source: tar_mirna_profiling/OUTPUT
      - id: s3cfg_section
        source: s3cfg_section
      - id: s3uri
        source: load_bucket
        valueFrom: $(self + "/" + inputs.task_uuid + "/")
      - id: task_uuid
        source: task_uuid
        valueFrom: $(null)
    out:
      - id: output

  - id: load_mirna_profiling_isoforms_quant
    run: ../../tools/aws_s3_put.cwl
    in:
      - id: aws_config
        source: aws_config
      - id: aws_shared_credentials
        source: aws_shared_credentials
      - id: endpoint_json
        source: endpoint_json
      - id: input
        source: rename_isoforms_quant/OUTPUT
      - id: s3cfg_section
        source: s3cfg_section
      - id: s3uri
        source: load_bucket
        valueFrom: $(self + "/" + inputs.task_uuid + "/")
      - id: task_uuid
        source: task_uuid
        valueFrom: $(null)
    out:
      - id: output

  - id: load_mirna_profiling_mirnas_quant
    run: ../../tools/aws_s3_put.cwl
    in:
      - id: aws_config
        source: aws_config
      - id: aws_shared_credentials
        source: aws_shared_credentials
      - id: endpoint_json
        source: endpoint_json
      - id: input
        source: rename_mirnas_quant/OUTPUT
      - id: s3cfg_section
        source: s3cfg_section
      - id: s3uri
        source: load_bucket
        valueFrom: $(self + "/" + inputs.task_uuid + "/")
      - id: task_uuid
        source: task_uuid
        valueFrom: $(null)
    out:
      - id: output

  - id: generate_s3_bam_url
    run: ../../tools/generate_s3load_path.cwl
    in:
      - id: load_bucket
        source: load_bucket
      - id: filename
        source: transform/picard_markduplicates_output
        valueFrom: $(self.basename)
      - id: task_uuid
        source: task_uuid
    out:
      - id: output

  - id: generate_s3_bai_url
    run: ../../tools/generate_s3load_path.cwl
    in:
      - id: load_bucket
        source: load_bucket
      - id: filename
        source: transform/picard_markduplicates_output
        valueFrom: $(self.secondaryFiles[0].basename)
      - id: task_uuid
        source: task_uuid
    out:
      - id: output

  - id: generate_s3_mirna_profiling_tar_url
    run: ../../tools/generate_s3load_path.cwl
    in:
      - id: load_bucket
        source: load_bucket
      - id: filename
        source: task_uuid
        valueFrom: $(self)_mirna_profiling.tar.xz
      - id: task_uuid
        source: task_uuid
    out:
      - id: output

  - id: generate_s3_mirna_profiling_isoforms_quant_url
    run: ../../tools/generate_s3load_path.cwl
    in:
      - id: load_bucket
        source: load_bucket
      - id: filename
        source: input_bam_gdc_id
        valueFrom: $(self).mirbase21.isoforms.quantification.txt
      - id: task_uuid
        source: task_uuid
    out:
      - id: output

  - id: generate_s3_mirna_profiling_mirnas_quant_url
    run: ../../tools/generate_s3load_path.cwl
    in:
      - id: load_bucket
        source: load_bucket
      - id: filename
        source: input_bam_gdc_id
        valueFrom: $(self).mirbase21.mirnas.quantification.txt
      - id: task_uuid
        source: task_uuid
    out:
      - id: output

  - id: generate_s3_sqlite_url
    run: ../../tools/generate_s3load_path.cwl
    in:
      - id: load_bucket
        source: load_bucket
      - id: filename
        source: transform/merge_all_sqlite_destination_sqlite
        valueFrom: $(self.basename)
      - id: task_uuid
        source: task_uuid
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
