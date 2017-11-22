#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: MultipleInputFeatureRequirement
  - class: ScatterFeatureRequirement
  - class: StepInputExpressionRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  - id: input_bam
    type: File
  - id: known_snp
    type: File
  - id: reference_sequence
    type: File
  - id: thread_count
    type: long
  - id: task_uuid
    type: string

outputs:
  - id: picard_markduplicates_output
    type: File
    outputSource: picard_markduplicates/OUTPUT
  - id: merge_all_sqlite_destination_sqlite
    type: File
    outputSource: merge_all_sqlite/destination_sqlite
  - id: mirna_profiling_mirna_adapter_report_sorted_output
    type: File
    outputSource: mirna_profiling/mirna_adapter_report_sorted_output
  - id: mirna_profiling_mirna_alignment_stats_alignment_stats_csv
    type: File
    outputSource: mirna_profiling/mirna_alignment_stats_alignment_stats_csv
  - id: mirna_profiling_mirna_alignment_stats_3_UTR_txt
    type: File
    outputSource: mirna_profiling/mirna_alignment_stats_3_UTR_txt
  - id: mirna_profiling_mirna_alignment_stats_5_UTR_txt
    type: File
    outputSource: mirna_profiling/mirna_alignment_stats_5_UTR_txt
  - id: mirna_profiling_mirna_alignment_stats_Coding_Exon_txt
    type: File
    outputSource: mirna_profiling/mirna_alignment_stats_Coding_Exon_txt
  - id: mirna_profiling_mirna_alignment_stats_Intron_txt
    type: File
    outputSource: mirna_profiling/mirna_alignment_stats_Intron_txt
  - id: mirna_profiling_mirna_alignment_stats_LINE_txt
    type: File
    outputSource: mirna_profiling/mirna_alignment_stats_LINE_txt
  - id: mirna_profiling_mirna_alignment_stats_LTR_txt
    type: File
    outputSource: mirna_profiling/mirna_alignment_stats_LTR_txt
  - id: mirna_profiling_mirna_alignment_stats_SINE_txt
    type: File
    outputSource: mirna_profiling/mirna_alignment_stats_SINE_txt
  - id: mirna_profiling_mirna_alignment_stats_bed
    type:
      type: array
      items: File
    outputSource: mirna_profiling/mirna_alignment_stats_bed
  - id: mirna_profiling_mirna_alignment_stats_chastity_taglengths_csv
    type: File
    outputSource: mirna_profiling/mirna_alignment_stats_chastity_taglengths_csv
  - id: mirna_profiling_mirna_alignment_stats_crossmapped_txt
    type: File
    outputSource: mirna_profiling/mirna_alignment_stats_crossmapped_txt
  - id: mirna_profiling_mirna_alignment_stats_filtered_taglengths_csv
    type: File
    outputSource: mirna_profiling/mirna_alignment_stats_filtered_taglengths_csv
  - id: mirna_profiling_mirna_alignment_stats_isoforms_txt
    type: File
    outputSource: mirna_profiling/mirna_alignment_stats_isoforms_txt
  - id: mirna_profiling_mirna_alignment_stats_miRNA_txt
    type: File
    outputSource: mirna_profiling/mirna_alignment_stats_miRNA_txt
  - id: mirna_profiling_mirna_alignment_stats_mirna_species_txt
    type: File
    outputSource: mirna_profiling/mirna_alignment_stats_mirna_species_txt
  - id: mirna_profiling_mirna_alignment_stats_rmsk_DNA_txt
    type: File
    outputSource: mirna_profiling/mirna_alignment_stats_rmsk_DNA_txt
  - id: mirna_profiling_mirna_alignment_stats_rmsk_RNA_txt
    type: File
    outputSource: mirna_profiling/mirna_alignment_stats_rmsk_RNA_txt
  - id: mirna_profiling_mirna_alignment_stats_rmsk_Simple_repeat_txt
    type: File
    outputSource: mirna_profiling/mirna_alignment_stats_rmsk_Simple_repeat_txt
  - id: mirna_profiling_mirna_alignment_stats_rmsk_Unknown_txt
    type: File
    outputSource: mirna_profiling/mirna_alignment_stats_rmsk_Unknown_txt
  - id: mirna_profiling_mirna_alignment_stats_rRNA_txt
    type: File
    outputSource: mirna_profiling/mirna_alignment_stats_rRNA_txt
  - id: mirna_profiling_mirna_alignment_stats_scRNA_txt
    type: File
    outputSource: mirna_profiling/mirna_alignment_stats_scRNA_txt
  - id: mirna_profiling_mirna_alignment_stats_snoRNA_txt
    type: File
    outputSource: mirna_profiling/mirna_alignment_stats_snoRNA_txt
  - id: mirna_profiling_mirna_alignment_stats_snRNA_txt
    type: File
    outputSource: mirna_profiling/mirna_alignment_stats_snRNA_txt
  - id: mirna_profiling_mirna_alignment_stats_softclip_taglengths_csv
    type: File
    outputSource: mirna_profiling/mirna_alignment_stats_softclip_taglengths_csv
  - id: mirna_profiling_mirna_alignment_stats_srpRNA_txt
    type: File
    outputSource: mirna_profiling/mirna_alignment_stats_srpRNA_txt
  - id: mirna_profiling_mirna_expression_matrix_expn_matrix_txt
    type: File
    outputSource: mirna_profiling/mirna_expression_matrix_expn_matrix_txt
  - id: mirna_profiling_mirna_expression_matrix_expn_matrix_norm_txt
    type: File
    outputSource: mirna_profiling/mirna_expression_matrix_expn_matrix_norm_txt
  - id: mirna_profiling_mirna_expression_matrix_expn_matrix_norm_log_txt
    type: File
    outputSource: mirna_profiling/mirna_expression_matrix_expn_matrix_norm_log_txt
  - id: mirna_profiling_mirna_expression_matrix_mimat_expn_matrix_mimat_txt
    type: File
    outputSource: mirna_profiling/mirna_expression_matrix_mimat_expn_matrix_mimat_txt
  - id: mirna_profiling_mirna_expression_matrix_mimat_expn_matrix_mimat_norm_txt
    type: File
    outputSource: mirna_profiling/mirna_expression_matrix_mimat_expn_matrix_mimat_norm_txt
  - id: mirna_profiling_mirna_expression_matrix_mimat_expn_matrix_mimat_norm_log_txt
    type: File
    outputSource: mirna_profiling/mirna_expression_matrix_mimat_expn_matrix_mimat_norm_log_txt
  - id: mirna_profiling_mirna_graph_libs_adapter_jpg
    type: File
    outputSource: mirna_profiling/mirna_graph_libs_adapter_jpg
  - id: mirna_profiling_mirna_graph_libs_chastity_jpg
    type: File
    outputSource: mirna_profiling/mirna_graph_libs_chastity_jpg
  - id: mirna_profiling_mirna_graph_libs_saturation_jpg
    type: File
    outputSource: mirna_profiling/mirna_graph_libs_saturation_jpg
  - id: mirna_profiling_mirna_graph_libs_softclip_jpg
    type: File
    outputSource: mirna_profiling/mirna_graph_libs_softclip_jpg
  - id: mirna_profiling_mirna_graph_libs_tags_jpg
    type: File
    outputSource: mirna_profiling/mirna_graph_libs_tags_jpg
  - id: mirna_profiling_mirna_tcga_isoforms_quant
    type: File
    outputSource: mirna_profiling/mirna_tcga_isoforms_quant
  - id: mirna_profiling_mirna_tcga_mirnas_quant
    type: File
    outputSource: mirna_profiling/mirna_tcga_mirnas_quant

steps:
  - id: samtools_bamtobam
    run: ../../tools/samtools_bamtobam.cwl
    in:
      - id: INPUT
        source: input_bam
    out:
      - id: OUTPUT

  - id: picard_validatesamfile_original
    run: ../../tools/picard_validatesamfile.cwl
    in:
      - id: INPUT
        source: samtools_bamtobam/OUTPUT
      - id: VALIDATION_STRINGENCY
        valueFrom: "LENIENT"
    out:
      - id: OUTPUT

  # need eof and dup QNAME detection
  - id: picard_validatesamfile_original_to_sqlite
    run: ../../tools/picard_validatesamfile_to_sqlite.cwl
    in:
      - id: bam
        source: input_bam
        valueFrom: $(self.basename)
      - id: input_state
        valueFrom: "original"
      - id: metric_path
        source: picard_validatesamfile_original/OUTPUT
      - id: task_uuid
        source: task_uuid
    out:
      - id: sqlite

  - id: biobambam_bamtofastq
    run: ../../tools/biobambam2_bamtofastq.cwl
    in:
      - id: filename
        source: samtools_bamtobam/OUTPUT
    out:
      - id: output_fastq1
      - id: output_fastq2
      - id: output_fastq_o1
      - id: output_fastq_o2
      - id: output_fastq_s

  - id: remove_duplicate_fastq1
    run: ../../tools/fastq_remove_duplicate_qname.cwl
    scatter: INPUT
    in:
      - id: INPUT
        source: biobambam_bamtofastq/output_fastq1
    out:
      - id: OUTPUT

  - id: remove_duplicate_fastq2
    run: ../../tools/fastq_remove_duplicate_qname.cwl
    scatter: INPUT
    in:
      - id: INPUT
        source: biobambam_bamtofastq/output_fastq2
    out:
      - id: OUTPUT

  - id: remove_duplicate_fastq_o1
    run: ../../tools/fastq_remove_duplicate_qname.cwl
    scatter: INPUT
    in:
      - id: INPUT
        source: biobambam_bamtofastq/output_fastq_o1
    out:
      - id: OUTPUT

  - id: remove_duplicate_fastq_o2
    run: ../../tools/fastq_remove_duplicate_qname.cwl
    scatter: INPUT
    in:
      - id: INPUT
        source: biobambam_bamtofastq/output_fastq_o2
    out:
      - id: OUTPUT

  - id: remove_duplicate_fastq_s
    run: ../../tools/fastq_remove_duplicate_qname.cwl
    scatter: INPUT
    in:
      - id: INPUT
        source: biobambam_bamtofastq/output_fastq_s
    out:
      - id: OUTPUT

  - id: sort_scattered_fastq1
    run: ../../tools/sort_scatter_expression.cwl
    in:
      - id: INPUT
        source: remove_duplicate_fastq1/OUTPUT
    out:
      - id: OUTPUT

  - id: sort_scattered_fastq2
    run: ../../tools/sort_scatter_expression.cwl
    in:
      - id: INPUT
        source: remove_duplicate_fastq2/OUTPUT
    out:
      - id: OUTPUT

  - id: sort_scattered_fastq_o1
    run: ../../tools/sort_scatter_expression.cwl
    in:
      - id: INPUT
        source: remove_duplicate_fastq_o1/OUTPUT
    out:
      - id: OUTPUT

  - id: sort_scattered_fastq_o2
    run: ../../tools/sort_scatter_expression.cwl
    in:
      - id: INPUT
        source: remove_duplicate_fastq_o2/OUTPUT
    out:
      - id: OUTPUT

  - id: sort_scattered_fastq_s
    run: ../../tools/sort_scatter_expression.cwl
    in:
      - id: INPUT
        source: remove_duplicate_fastq_s/OUTPUT
    out:
      - id: OUTPUT

  - id: bam_readgroup_to_json
    run: ../../tools/bam_readgroup_to_json.cwl
    in:
      - id: INPUT
        source: samtools_bamtobam/OUTPUT
      - id: MODE
        valueFrom: "lenient"
    out:
      - id: OUTPUT

  - id: readgroup_json_db
    run: ../../tools/readgroup_json_db.cwl
    scatter: json_path
    in:
      - id: json_path
        source: bam_readgroup_to_json/OUTPUT
      - id: task_uuid
        source: task_uuid
    out:
      - id: log
      - id: output_sqlite

  - id: merge_readgroup_json_db
    run: ../../tools/merge_sqlite.cwl
    in:
      - id: source_sqlite
        source: readgroup_json_db/output_sqlite
      - id: task_uuid
        source: task_uuid
    out:
      - id: destination_sqlite
      - id: log

  - id: fastqc1
    run: ../../tools/fastqc.cwl
    scatter: INPUT
    in:
      - id: INPUT
        source: sort_scattered_fastq1/OUTPUT
      - id: threads
        source: thread_count
    out:
      - id: OUTPUT

  - id: fastqc2
    run: ../../tools/fastqc.cwl
    scatter: INPUT
    in:
      - id: INPUT
        source: sort_scattered_fastq2/OUTPUT
      - id: threads
        source: thread_count
    out:
      - id: OUTPUT

  - id: fastqc_s
    run: ../../tools/fastqc.cwl
    scatter: INPUT
    in:
      - id: INPUT
        source: sort_scattered_fastq_s/OUTPUT
      - id: threads
        source: thread_count
    out:
      - id: OUTPUT

  - id: fastqc_o1
    run: ../../tools/fastqc.cwl
    scatter: INPUT
    in:
      - id: INPUT
        source: sort_scattered_fastq_o1/OUTPUT
      - id: threads
        source: thread_count
    out:
      - id: OUTPUT

  - id: fastqc_o2
    run: ../../tools/fastqc.cwl
    scatter: INPUT
    in:
      - id: INPUT
        source: sort_scattered_fastq_o2/OUTPUT
      - id: threads
        source: thread_count
    out:
      - id: OUTPUT

  - id: fastqc_db1
    run: ../../tools/fastqc_db.cwl
    scatter: INPUT
    in:
      - id: INPUT
        source: fastqc1/OUTPUT
      - id: task_uuid
        source: task_uuid
    out:
      - id: LOG
      - id: OUTPUT

  - id: fastqc_db2
    run: ../../tools/fastqc_db.cwl
    scatter: INPUT
    in:
      - id: INPUT
        source: fastqc2/OUTPUT
      - id: task_uuid
        source: task_uuid
    out:
      - id: LOG
      - id: OUTPUT

  - id: fastqc_db_s
    run: ../../tools/fastqc_db.cwl
    scatter: INPUT
    in:
      - id: INPUT
        source: fastqc_s/OUTPUT
      - id: task_uuid
        source: task_uuid
    out:
      - id: LOG
      - id: OUTPUT

  - id: fastqc_db_o1
    run: ../../tools/fastqc_db.cwl
    scatter: INPUT
    in:
      - id: INPUT
        source: fastqc_o1/OUTPUT
      - id: task_uuid
        source: task_uuid
    out:
      - id: LOG
      - id: OUTPUT

  - id: fastqc_db_o2
    run: ../../tools/fastqc_db.cwl
    scatter: INPUT
    in:
      - id: INPUT
        source: fastqc_o2/OUTPUT
      - id: task_uuid
        source: task_uuid
    out:
      - id: LOG
      - id: OUTPUT

  - id: merge_fastqc_db1_sqlite
    run: ../../tools/merge_sqlite.cwl
    in:
      - id: source_sqlite
        source: fastqc_db1/OUTPUT
      - id: task_uuid
        source: task_uuid
    out:
      - id: destination_sqlite
      - id: log

  - id: merge_fastqc_db2_sqlite
    run: ../../tools/merge_sqlite.cwl
    in:
      - id: source_sqlite
        source: fastqc_db2/OUTPUT
      - id: task_uuid
        source: task_uuid
    out:
      - id: destination_sqlite
      - id: log

  - id: merge_fastqc_db_s_sqlite
    run: ../../tools/merge_sqlite.cwl
    in:
      - id: source_sqlite
        source: fastqc_db_s/OUTPUT
      - id: task_uuid
        source: task_uuid
    out:
      - id: destination_sqlite
      - id: log

  - id: merge_fastqc_db_o1_sqlite
    run: ../../tools/merge_sqlite.cwl
    in:
      - id: source_sqlite
        source: fastqc_db_o1/OUTPUT
      - id: task_uuid
        source: task_uuid
    out:
      - id: destination_sqlite
      - id: log

  - id: merge_fastqc_db_o2_sqlite
    run: ../../tools/merge_sqlite.cwl
    in:
      - id: source_sqlite
        source: fastqc_db_o2/OUTPUT
      - id: task_uuid
        source: task_uuid
    out:
      - id: destination_sqlite
      - id: log

  - id: fastqc_pe_basicstats_json
    run: ../../tools/fastqc_basicstatistics_json.cwl
    in:
      - id: sqlite_path
        source: merge_fastqc_db1_sqlite/destination_sqlite
    out:
      - id: OUTPUT

  - id: fastqc_se_basicstats_json
    run: ../../tools/fastqc_basicstatistics_json.cwl
    in:
      - id: sqlite_path
        source: merge_fastqc_db_s_sqlite/destination_sqlite
    out:
      - id: OUTPUT

  - id: fastqc_o1_basicstats_json
    run: ../../tools/fastqc_basicstatistics_json.cwl
    in:
      - id: sqlite_path
        source: merge_fastqc_db_o1_sqlite/destination_sqlite
    out:
      - id: OUTPUT

  - id: fastqc_o2_basicstats_json
    run: ../../tools/fastqc_basicstatistics_json.cwl
    in:
      - id: sqlite_path
        source: merge_fastqc_db_o2_sqlite/destination_sqlite
    out:
      - id: OUTPUT

  - id: decider_bwa_pe
    run: ../../tools/decider_bwa_expression.cwl
    in:
      - id: fastq_path
        source: sort_scattered_fastq1/OUTPUT
      - id: readgroup_path
        source: bam_readgroup_to_json/OUTPUT
    out:
      - id: output_readgroup_paths

  - id: decider_bwa_se
    run: ../../tools/decider_bwa_expression.cwl
    in:
      - id: fastq_path
        source: sort_scattered_fastq_s/OUTPUT
      - id: readgroup_path
        source: bam_readgroup_to_json/OUTPUT
    out:
      - id: output_readgroup_paths

  - id: decider_bwa_o1
    run: ../../tools/decider_bwa_expression.cwl
    in:
      - id: fastq_path
        source: sort_scattered_fastq_o1/OUTPUT
      - id: readgroup_path
        source: bam_readgroup_to_json/OUTPUT
    out:
      - id: output_readgroup_paths

  - id: decider_bwa_o2
    run: ../../tools/decider_bwa_expression.cwl
    in:
      - id: fastq_path
        source: sort_scattered_fastq_o2/OUTPUT
      - id: readgroup_path
        source: bam_readgroup_to_json/OUTPUT
    out:
      - id: output_readgroup_paths

  - id: bwa_pe
    run: ../../tools/bwa_pe.cwl
    scatter: [fastq1, fastq2, readgroup_json_path]
    scatterMethod: "dotproduct"
    in:
      - id: fasta
        source: reference_sequence
      - id: fastq1
        source: sort_scattered_fastq1/OUTPUT
      - id: fastq2
        source: sort_scattered_fastq2/OUTPUT
      - id: readgroup_json_path
        source: decider_bwa_pe/output_readgroup_paths
      - id: fastqc_json_path
        source: fastqc_pe_basicstats_json/OUTPUT
      - id: thread_count
        source: thread_count
    out:
      - id: OUTPUT

  - id: bwa_se
    run: ../../tools/bwa_se.cwl
    scatter: [fastq, readgroup_json_path]
    scatterMethod: "dotproduct"
    in:
      - id: fasta
        source: reference_sequence
      - id: fastq
        source: sort_scattered_fastq_s/OUTPUT
      - id: readgroup_json_path
        source: decider_bwa_se/output_readgroup_paths
      - id: fastqc_json_path
        source: fastqc_se_basicstats_json/OUTPUT
      - id: samse_maxOcc
        valueFrom: $(5+5)
      - id: thread_count
        source: thread_count
    out:
      - id: OUTPUT

  - id: bwa_o1
    run: ../../tools/bwa_se.cwl
    scatter: [fastq, readgroup_json_path]
    scatterMethod: "dotproduct"
    in:
      - id: fasta
        source: reference_sequence
      - id: fastq
        source: sort_scattered_fastq_o1/OUTPUT
      - id: readgroup_json_path
        source: decider_bwa_o1/output_readgroup_paths
      - id: fastqc_json_path
        source: fastqc_o1_basicstats_json/OUTPUT
      - id: thread_count
        source: thread_count
    out:
      - id: OUTPUT

  - id: bwa_o2
    run: ../../tools/bwa_se.cwl
    scatter: [fastq, readgroup_json_path]
    scatterMethod: "dotproduct"
    in:
      - id: fasta
        source: reference_sequence
      - id: fastq
        source: sort_scattered_fastq_o2/OUTPUT
      - id: readgroup_json_path
        source: decider_bwa_o2/output_readgroup_paths
      - id: fastqc_json_path
        source: fastqc_o2_basicstats_json/OUTPUT
      - id: thread_count
        source: thread_count
    out:
      - id: OUTPUT

  - id: picard_sortsam_pe
    run: ../../tools/picard_sortsam.cwl
    scatter: INPUT
    in:
      - id: INPUT
        source: bwa_pe/OUTPUT
      - id: OUTPUT
        valueFrom: $(inputs.INPUT.basename)
    out:
      - id: SORTED_OUTPUT

  - id: picard_sortsam_se
    run: ../../tools/picard_sortsam.cwl
    scatter: INPUT
    in:
      - id: INPUT
        source: bwa_se/OUTPUT
      - id: OUTPUT
        valueFrom: $(inputs.INPUT.basename)
    out:
      - id: SORTED_OUTPUT

  - id: picard_sortsam_o1
    run: ../../tools/picard_sortsam.cwl
    scatter: INPUT
    in:
      - id: INPUT
        source: bwa_o1/OUTPUT
      - id: OUTPUT
        valueFrom: $(inputs.INPUT.basename)
    out:
      - id: SORTED_OUTPUT

  - id: picard_sortsam_o2
    run: ../../tools/picard_sortsam.cwl
    scatter: INPUT
    in:
      - id: INPUT
        source: bwa_o2/OUTPUT
      - id: OUTPUT
        valueFrom: $(inputs.INPUT.basename)
    out:
      - id: SORTED_OUTPUT

  - id: metrics_pe
    run: metrics.cwl
    scatter: bam
    in:
      - id: bam
        source: picard_sortsam_pe/SORTED_OUTPUT
      - id: known_snp
        source: known_snp
      - id: fasta
        source: reference_sequence
      - id: input_state
        valueFrom: "sorted_readgroup"
      - id: parent_bam
        source: input_bam
        valueFrom: $(self.basename)
      - id: thread_count
        source: thread_count
      - id: task_uuid
        source: task_uuid
    out:
      - id: merge_sqlite_destination_sqlite

  - id: merge_metrics_pe
    run: ../../tools/merge_sqlite.cwl
    in:
      - id: source_sqlite
        source: metrics_pe/merge_sqlite_destination_sqlite
      - id: task_uuid
        source: task_uuid
    out:
      - id: destination_sqlite
      - id: log

  - id: metrics_se
    run: metrics.cwl
    scatter: bam
    in:
      - id: bam
        source: picard_sortsam_se/SORTED_OUTPUT
      - id: known_snp
        source: known_snp
      - id: fasta
        source: reference_sequence
      - id: input_state
        valueFrom: "sorted_readgroup"
      - id: parent_bam
        source: input_bam
        valueFrom: $(self.basename)
      - id: thread_count
        source: thread_count
      - id: task_uuid
        source: task_uuid
    out:
      - id: merge_sqlite_destination_sqlite

  - id: merge_metrics_se
    run: ../../tools/merge_sqlite.cwl
    in:
      - id: source_sqlite
        source: metrics_se/merge_sqlite_destination_sqlite
      - id: task_uuid
        source: task_uuid
    out:
      - id: destination_sqlite
      - id: log

  - id: picard_mergesamfiles_pe
    run: ../../tools/picard_mergesamfiles.cwl
    in:
      - id: INPUT
        source: picard_sortsam_pe/SORTED_OUTPUT
      - id: OUTPUT
        source: input_bam
        valueFrom: $(self.basename)
    out:
      - id: MERGED_OUTPUT

  - id: picard_mergesamfiles_se
    run: ../../tools/picard_mergesamfiles.cwl
    in:
      - id: INPUT
        source: picard_sortsam_se/SORTED_OUTPUT
      - id: OUTPUT
        source: input_bam
        valueFrom: $(self.basename)
    out:
      - id: MERGED_OUTPUT

  - id: picard_mergesamfiles_o1
    run: ../../tools/picard_mergesamfiles.cwl
    in:
      - id: INPUT
        source: picard_sortsam_o1/SORTED_OUTPUT
      - id: OUTPUT
        source: input_bam
        valueFrom: $(self.basename)
    out:
      - id: MERGED_OUTPUT

  - id: picard_mergesamfiles_o2
    run: ../../tools/picard_mergesamfiles.cwl
    in:
      - id: INPUT
        source: picard_sortsam_o2/SORTED_OUTPUT
      - id: OUTPUT
        source: input_bam
        valueFrom: $(self.basename)
    out:
      - id: MERGED_OUTPUT

  - id: picard_mergesamfiles
    run: ../../tools/picard_mergesamfiles.cwl
    in:
      - id: INPUT
        source: [
        picard_mergesamfiles_pe/MERGED_OUTPUT,
        picard_mergesamfiles_se/MERGED_OUTPUT,
        picard_mergesamfiles_o1/MERGED_OUTPUT,
        picard_mergesamfiles_o2/MERGED_OUTPUT
        ]
      - id: OUTPUT
        source: input_bam
        valueFrom: $(self.basename.slice(0,-4) + "_gdc_realn.bam")
    out:
      - id: MERGED_OUTPUT

  - id: bam_reheader
    run: ../../tools/bam_reheader.cwl
    in:
      - id: input
        source: picard_mergesamfiles/MERGED_OUTPUT
    out:
      - id: output

  - id: picard_markduplicates
    run: ../../tools/picard_markduplicates.cwl
    in:
      - id: INPUT
        source: bam_reheader/output
    out:
      - id: OUTPUT
      - id: METRICS

  - id: picard_markduplicates_to_sqlite
    run: ../../tools/picard_markduplicates_to_sqlite.cwl
    in:
      - id: bam
        source: picard_markduplicates/OUTPUT
        valueFrom: $(self.basename)
      - id: input_state
        valueFrom: "markduplicates_readgroups"
      - id: metric_path
        source: picard_markduplicates/METRICS
      - id: task_uuid
        source: task_uuid
    out:
      - id: sqlite

  - id: picard_validatesamfile_markduplicates
    run: ../../tools/picard_validatesamfile.cwl
    in:
      - id: INPUT
        source: picard_markduplicates/OUTPUT
      - id: VALIDATION_STRINGENCY
        valueFrom: "STRICT"
    out:
      - id: OUTPUT

  #need eof and dup QNAME detection
  - id: picard_validatesamfile_markdupl_to_sqlite
    run: ../../tools/picard_validatesamfile_to_sqlite.cwl
    in:
      - id: bam
        source: input_bam
        valueFrom: $(self.basename)
      - id: input_state
        valueFrom: "markduplicates_readgroups"
      - id: metric_path
        source: picard_validatesamfile_markduplicates/OUTPUT
      - id: task_uuid
        source: task_uuid
    out:
      - id: sqlite

  - id: metrics_markduplicates
    run: mixed_library_metrics.cwl
    in:
      - id: bam
        source: picard_markduplicates/OUTPUT
      - id: known_snp
        source: known_snp
      - id: fasta
        source: reference_sequence
      - id: input_state
        valueFrom: "markduplicates_readgroups"
      - id: thread_count
        source: thread_count
      - id: task_uuid
        source: task_uuid
    out:
      - id: merge_sqlite_destination_sqlite

  - id: mirna_profiling
    run: mirna_profiling.cwl
    in:
      - id: awk_expression
        valueFrom: "{arr[length($10)]+=1} END {for (i in arr) {print i\" \"arr[i]}}"
      - id: bam
        source: picard_markduplicates/OUTPUT
      - id: mirbase_db
        valueFrom: "mirbase"
      - id: species_code
        valueFrom: "hsa"
      - id: project_directory
        valueFrom: "."
      - id: ucsc_database
        valueFrom: "hg38"
    out:
      - id: mirna_adapter_report_sorted_output
      - id: mirna_alignment_stats_alignment_stats_csv
      - id: mirna_alignment_stats_3_UTR_txt
      - id: mirna_alignment_stats_5_UTR_txt
      - id: mirna_alignment_stats_Coding_Exon_txt
      - id: mirna_alignment_stats_Intron_txt
      - id: mirna_alignment_stats_LINE_txt
      - id: mirna_alignment_stats_LTR_txt
      - id: mirna_alignment_stats_SINE_txt
      - id: mirna_alignment_stats_bed
      - id: mirna_alignment_stats_chastity_taglengths_csv
      - id: mirna_alignment_stats_crossmapped_txt
      - id: mirna_alignment_stats_filtered_taglengths_csv
      - id: mirna_alignment_stats_isoforms_txt
      - id: mirna_alignment_stats_miRNA_txt
      - id: mirna_alignment_stats_mirna_species_txt
      - id: mirna_alignment_stats_rmsk_DNA_txt
      - id: mirna_alignment_stats_rmsk_RNA_txt
      - id: mirna_alignment_stats_rmsk_Simple_repeat_txt
      - id: mirna_alignment_stats_rmsk_Unknown_txt
      - id: mirna_alignment_stats_rRNA_txt
      - id: mirna_alignment_stats_scRNA_txt
      - id: mirna_alignment_stats_snoRNA_txt
      - id: mirna_alignment_stats_snRNA_txt
      - id: mirna_alignment_stats_softclip_taglengths_csv
      - id: mirna_alignment_stats_srpRNA_txt
      - id: mirna_expression_matrix_expn_matrix_txt
      - id: mirna_expression_matrix_expn_matrix_norm_txt
      - id: mirna_expression_matrix_expn_matrix_norm_log_txt
      - id: mirna_expression_matrix_mimat_expn_matrix_mimat_txt
      - id: mirna_expression_matrix_mimat_expn_matrix_mimat_norm_txt
      - id: mirna_expression_matrix_mimat_expn_matrix_mimat_norm_log_txt
      - id: mirna_graph_libs_adapter_jpg
      - id: mirna_graph_libs_chastity_jpg
      - id: mirna_graph_libs_saturation_jpg
      - id: mirna_graph_libs_softclip_jpg
      - id: mirna_graph_libs_tags_jpg
      - id: mirna_tcga_isoforms_quant
      - id: mirna_tcga_mirnas_quant
        
  - id: integrity
    run: integrity.cwl
    in:
      - id: bai
        source: picard_markduplicates/OUTPUT
        valueFrom: $(self.secondaryFiles[0])
      - id: bam
        source: picard_markduplicates/OUTPUT
      - id: input_state
        valueFrom: "markduplicates_readgroups"
      - id: task_uuid
        source: task_uuid
    out:
      - id: merge_sqlite_destination_sqlite

  - id: merge_all_sqlite
    run: ../../tools/merge_sqlite.cwl
    in:
      - id: source_sqlite
        source: [
          picard_validatesamfile_original_to_sqlite/sqlite,
          picard_validatesamfile_markdupl_to_sqlite/sqlite,
          merge_readgroup_json_db/destination_sqlite,
          merge_fastqc_db1_sqlite/destination_sqlite,
          merge_fastqc_db2_sqlite/destination_sqlite,
          merge_fastqc_db_s_sqlite/destination_sqlite,
          merge_fastqc_db_o1_sqlite/destination_sqlite,
          merge_fastqc_db_o2_sqlite/destination_sqlite,
          merge_metrics_pe/destination_sqlite,
          merge_metrics_se/destination_sqlite,
          metrics_markduplicates/merge_sqlite_destination_sqlite,
          picard_markduplicates_to_sqlite/sqlite,
          integrity/merge_sqlite_destination_sqlite
        ]
      - id: task_uuid
        source: task_uuid
    out:
      - id: destination_sqlite
      - id: log
