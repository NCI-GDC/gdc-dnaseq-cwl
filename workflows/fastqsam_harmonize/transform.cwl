#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - $import: ../../tools/readgroup.yml
  - class: InlineJavascriptRequirement
  - class: MultipleInputFeatureRequirement
  - class: ScatterFeatureRequirement
  - class: StepInputExpressionRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  - id: bam_name
    type: string
  - id: job_uuid
    type: string
  - id: readgroup_fastq_pe_path_list
    type:
      type: array
      items: ../../tools/readgroup.yml#readgroup_fastq_pe_file
  - id: readgroup_fastq_se_path_list
    type:
      type: array
      items: ../../tools/readgroup.yml#readgroup_fastq_se_file
  - id: readgroups_bam_path_list
    type:
      type: array
      items: ../../tools/readgroup.yml#readgroups_bam_file
  - id: known_snp
    type: File
  - id: reference_sequence
    type: File
  - id: thread_count
    type: long

outputs:
  - id: output_bam
    type: File
    outputSource: gatk_applybqsr/output_bam
  # - id: sqlite
  #   type: File
  #   outputSource: merge_all_sqlite/destination_sqlite

steps:
  - id: readgroups_bam_to_readgroups_fastq_lists
    run: readgroups_bam_to_readgroups_fastq_lists.cwl
    scatter: readgroups_bam_file
    in:
      - id: readgroups_bam_file
        source: readgroups_bam_path_list
    out:
      - id: pe_file_list
      - id: se_file_list
      - id: o1_file_list
      - id: o2_file_list

  - id: merge_bam_pe_fastq_records
    run: ../../tools/merge_pe_fastq_records.cwl
    in:
      - id: input
        source: readgroups_bam_to_readgroups_fastq_lists/pe_file_list
    out:
      - id: output

  - id: merge_pe_fastq_records
    run: ../../tools/merge_pe_fastq_records.cwl
    in:
      - id: input
        source: [
        merge_bam_pe_fastq_records/output,
        readgroup_fastq_pe_path_list
        ]
    out:
      - id: output

  - id: merge_bam_se_fastq_records
    run: ../../tools/merge_se_fastq_records.cwl
    in:
      - id: input
        source: readgroups_bam_to_readgroups_fastq_lists/se_file_list
    out:
      - id: output

  - id: merge_se_fastq_records
    run: ../../tools/merge_se_fastq_records.cwl
    in:
      - id: input
        source: [
        merge_bam_se_fastq_records/output,
        readgroup_fastq_se_path_list
        ]
    out:
      - id: output

  - id: merge_o1_fastq_records
    run: ../../tools/merge_se_fastq_records.cwl
    in:
      - id: input
        source: readgroups_bam_to_readgroups_fastq_lists/o1_file_list
    out:
      - id: output

  - id: merge_o2_fastq_records
    run: ../../tools/merge_se_fastq_records.cwl
    in:
      - id: input
        source: readgroups_bam_to_readgroups_fastq_lists/o2_file_list
    out:
      - id: output

  - id: bwa_pe
    run: bwa_pe.cwl
    scatter: readgroup_fastq_pe
    in:
      - id: job_uuid
        source: job_uuid
      - id: reference_sequence
        source: reference_sequence
      - id: readgroup_fastq_pe
        source: merge_pe_fastq_records/output
      - id: thread_count
        source: thread_count
    out:
      - id: bam
      - id: sqlite

  - id: bwa_se
    run: bwa_se.cwl
    scatter: readgroup_fastq_se
    in:
      - id: job_uuid
        source: job_uuid
      - id: reference_sequence
        source: reference_sequence
      - id: readgroup_fastq_se
        source: merge_se_fastq_records/output
      - id: thread_count
        source: thread_count
    out:
      - id: bam
      - id: sqlite

  - id: bwa_o1
    run: bwa_se.cwl
    scatter: readgroup_fastq_se
    in:
      - id: job_uuid
        source: job_uuid
      - id: reference_sequence
        source: reference_sequence
      - id: readgroup_fastq_se
        source: merge_o1_fastq_records/output
      - id: thread_count
        source: thread_count
    out:
      - id: bam
      - id: sqlite

  - id: bwa_o2
    run: bwa_se.cwl
    scatter: readgroup_fastq_se
    in:
      - id: job_uuid
        source: job_uuid
      - id: reference_sequence
        source: reference_sequence
      - id: readgroup_fastq_se
        source: merge_o2_fastq_records/output
      - id: thread_count
        source: thread_count
    out:
      - id: bam
      - id: sqlite

  # - id: metrics_pe
  #   run: metrics.cwl
  #   scatter: bam
  #   in:
  #     - id: bam
  #       source: picard_sortsam_pe/SORTED_OUTPUT
  #     - id: known_snp
  #       source: known_snp
  #     - id: fasta
  #       source: reference_sequence
  #     - id: input_state
  #       valueFrom: "sorted_readgroup"
  #     - id: parent_bam
  #       source: input_bam
  #       valueFrom: $(self.basename)
  #     - id: thread_count
  #       source: thread_count
  #     - id: job_uuid
  #       source: job_uuid
  #   out:
  #     - id: merge_sqlite_destination_sqlite

  # - id: merge_metrics_pe
  #   run: ../../tools/merge_sqlite.cwl
  #   in:
  #     - id: source_sqlite
  #       source: metrics_pe/merge_sqlite_destination_sqlite
  #     - id: job_uuid
  #       source: job_uuid
  #   out:
  #     - id: destination_sqlite
  #     - id: log

  # - id: metrics_se
  #   run: metrics.cwl
  #   scatter: bam
  #   in:
  #     - id: bam
  #       source: picard_sortsam_se/SORTED_OUTPUT
  #     - id: known_snp
  #       source: known_snp
  #     - id: fasta
  #       source: reference_sequence
  #     - id: input_state
  #       valueFrom: "sorted_readgroup"
  #     - id: parent_bam
  #       source: input_bam
  #       valueFrom: $(self.basename)
  #     - id: thread_count
  #       source: thread_count
  #     - id: job_uuid
  #       source: job_uuid
  #   out:
  #     - id: merge_sqlite_destination_sqlite

  # - id: merge_metrics_se
  #   run: ../../tools/merge_sqlite.cwl
  #   in:
  #     - id: source_sqlite
  #       source: metrics_se/merge_sqlite_destination_sqlite
  #     - id: job_uuid
  #       source: job_uuid
  #   out:
  #     - id: destination_sqlite
  #     - id: log

  # - id: picard_mergesamfiles_aligned_pe
  #   run: ../../tools/picard_mergesamfiles.cwl
  #   in:
  #     - id: INPUT
  #       source: picard_sortsam_pe/SORTED_OUTPUT
  #     - id: OUTPUT
  #       source: input_bam
  #       valueFrom: $(self.basename)
  #   out:
  #     - id: MERGED_OUTPUT

  # - id: picard_mergesamfiles_aligned_se
  #   run: ../../tools/picard_mergesamfiles.cwl
  #   in:
  #     - id: INPUT
  #       source: picard_sortsam_se/SORTED_OUTPUT
  #     - id: OUTPUT
  #       source: input_bam
  #       valueFrom: $(self.basename)
  #   out:
  #     - id: MERGED_OUTPUT

  # - id: picard_mergesamfiles_aligned_o1
  #   run: ../../tools/picard_mergesamfiles.cwl
  #   in:
  #     - id: INPUT
  #       source: picard_sortsam_o1/SORTED_OUTPUT
  #     - id: OUTPUT
  #       source: input_bam
  #       valueFrom: $(self.basename)
  #   out:
  #     - id: MERGED_OUTPUT

  # - id: picard_mergesamfiles_aligned_o2
  #   run: ../../tools/picard_mergesamfiles.cwl
  #   in:
  #     - id: INPUT
  #       source: picard_sortsam_o2/SORTED_OUTPUT
  #     - id: OUTPUT
  #       source: input_bam
  #       valueFrom: $(self.basename)
  #   out:
  #     - id: MERGED_OUTPUT

  - id: picard_mergesamfiles
    run: ../../tools/picard_mergesamfiles_aoa.cwl
    in:
      - id: INPUT
        source: [
        bwa_pe/bam,
        bwa_se/bam,
        bwa_o1/bam,
        bwa_o2/bam
        ]
      - id: OUTPUT
        source: bam_name
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

  # - id: picard_markduplicates_to_sqlite
  #   run: ../../tools/picard_markduplicates_to_sqlite.cwl
  #   in:
  #     - id: bam
  #       source: picard_markduplicates/OUTPUT
  #       valueFrom: $(self.basename)
  #     - id: input_state
  #       valueFrom: "markduplicates_readgroups"
  #     - id: metric_path
  #       source: picard_markduplicates/METRICS
  #     - id: job_uuid
  #       source: job_uuid
  #   out:
  #     - id: sqlite

  - id: gatk_baserecalibrator
    run: ../../tools/gatk4_baserecalibrator.cwl
    in:
      - id: input
        source: picard_markduplicates/OUTPUT
      - id: known-sites
        source: known_snp
      - id: reference
        source: reference_sequence
    out:
      - id: output_grp

  - id: gatk_applybqsr
    run: ../../tools/gatk4_applybqsr.cwl
    in:
      - id: input
        source: picard_markduplicates/OUTPUT
      - id: bqsr-recal-file
        source: gatk_baserecalibrator/output_grp
    out:
      - id: output_bam

  # - id: integrity
  #   run: integrity.cwl
  #   in:
  #     - id: bai
  #       source: gatk_applybqsr/output_bam
  #       valueFrom: $(self.secondaryFiles[0])
  #     - id: bam
  #       source: gatk_applybqsr/output_bam
  #     - id: input_state
  #       valueFrom: "gatk_applybqsr"
  #     - id: job_uuid
  #       source: job_uuid
  #   out:
  #     - id: merge_sqlite_destination_sqlite


  # - id: picard_validatesamfile_bqsr
  #   run: ../../tools/picard_validatesamfile.cwl
  #   in:
  #     - id: INPUT
  #       source: gatk_applybqsr/output_bam
  #     - id: VALIDATION_STRINGENCY
  #       valueFrom: "STRICT"
  #   out:
  #     - id: OUTPUT

  # #need eof and dup QNAME detection
  # - id: picard_validatesamfile_bqsr_to_sqlite
  #   run: ../../tools/picard_validatesamfile_to_sqlite.cwl
  #   in:
  #     - id: bam
  #       source: gatk_applybqsr/output_bam
  #       valueFrom: $(self.basename)
  #     - id: input_state
  #       valueFrom: "gatk_applybqsr_readgroups"
  #     - id: metric_path
  #       source: picard_validatesamfile_bqsr/OUTPUT
  #     - id: job_uuid
  #       source: job_uuid
  #   out:
  #     - id: sqlite

  # - id: metrics_bqsr
  #   run: mixed_library_metrics.cwl
  #   in:
  #     - id: bam
  #       source: gatk_applybqsr/output_bam
  #     - id: known_snp
  #       source: known_snp
  #     - id: fasta
  #       source: reference_sequence
  #     - id: input_state
  #       valueFrom: "gatk_applybqsr_readgroups"
  #     - id: thread_count
  #       source: thread_count
  #     - id: job_uuid
  #       source: job_uuid
  #   out:
  #     - id: merge_sqlite_destination_sqlite

  # # - id: integrity
  # #   run: integrity.cwl
  # #   in:
  # #     - id: bai
  # #       source: picard_markduplicates/OUTPUT
  # #       valueFrom: $(self.secondaryFiles[0])
  # #     - id: bam
  # #       source: picard_markduplicates/OUTPUT
  # #     - id: input_state
  # #       valueFrom: "markduplicates_readgroups"
  # #     - id: job_uuid
  # #       source: job_uuid
  # #   out:
  # #     - id: merge_sqlite_destination_sqlite

  # - id: merge_all_sqlite
  #   run: ../../tools/merge_sqlite.cwl
  #   in:
  #     - id: source_sqlite
  #       source: [
  #         picard_validatesamfile_original_to_sqlite/sqlite,
  #         picard_validatesamfile_bqsr_to_sqlite/sqlite,
  #         merge_readgroup_json_db/destination_sqlite,
  #         merge_fastqc_db1_sqlite/destination_sqlite,
  #         merge_fastqc_db2_sqlite/destination_sqlite,
  #         merge_fastqc_db_s_sqlite/destination_sqlite,
  #         merge_fastqc_db_o1_sqlite/destination_sqlite,
  #         merge_fastqc_db_o2_sqlite/destination_sqlite,
  #         merge_metrics_pe/destination_sqlite,
  #         merge_metrics_se/destination_sqlite,
  #         metrics_bqsr/merge_sqlite_destination_sqlite,
  #         picard_markduplicates_to_sqlite/sqlite,
  #         integrity/merge_sqlite_destination_sqlite
  #       ]
  #     - id: job_uuid
  #       source: job_uuid
  #   out:
  #     - id: destination_sqlite
  #     - id: log
