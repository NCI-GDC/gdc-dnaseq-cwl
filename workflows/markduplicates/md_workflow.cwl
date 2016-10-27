#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: MultipleInputFeatureRequirement
  - class: StepInputExpressionRequirement

inputs:
  - id: alignment_last_step
    type: string
  - id: bam_path
    type: File
  - id: fasta_path
    type: File
  - id: load_bucket
    type: string
  - id: uuid
    type: string
  - id: vcf_path
    type: File

outputs:
  - id: picard_markduplicates_output_bam
    type: File
    outputSource: picard_markduplicates/OUTPUT
  - id: merge_all_sqlite_destination_sqlite
    type: File
    outputSource: merge_all_sqlite/destination_sqlite

steps:
  - id: picard_validatesamfile_original
    run: ../../tools/picard_validatesamfile.cwl
    in:
      - id: INPUT
        source: bam_path
      - id: VALIDATION_STRINGENCY
        valueFrom: "LENIENT"
    out:
      - id: OUTPUT

  - id: picard_markduplicates
    run: ../../tools/picard_markduplicates.cwl
    in:
      - id: INPUT
        source: bam_path
      - id: VALIDATION_STRINGENCY
        valueFrom: "LENIENT"
    out:
      - id: OUTPUT
      - id: METRICS

  - id: picard_validatesamfile_markduplicates
    run: ../../tools/picard_validatesamfile.cwl
    in:
      - id: INPUT
        source: picard_markduplicates/OUTPUT
      - id: VALIDATION_STRINGENCY
        valueFrom: "LENIENT"
    out:
      - id: OUTPUT

  - id: picard_collectmultiplemetrics
    run: ../../tools/picard_collectmultiplemetrics.cwl
    in:
      - id: DB_SNP
        source: vcf_path
      - id: INPUT
        source: picard_markduplicates/OUTPUT
      - id: REFERENCE_SEQUENCE
        source: fasta_path
      - id: VALIDATION_STRINGENCY
        valueFrom: "LENIENT"
    out:
      - id: alignment_summary_metrics
      - id: bait_bias_detail_metrics
      - id: bait_bias_summary_metrics
      - id: base_distribution_by_cycle_metrics
      - id: gc_bias_detail_metrics
      - id: gc_bias_summary_metrics
      - id: insert_size_metrics
      - id: pre_adapter_detail_metrics
      - id: pre_adapter_summary_metrics
      - id: quality_by_cycle_metrics
      - id: quality_distribution_metrics
      - id: quality_yield_metrics

  - id: picard_collectoxogmetrics
    run: ../../tools/picard_collectoxogmetrics.cwl
    in:
      - id: DB_SNP
        source: vcf_path
      - id: INPUT
        source: picard_markduplicates/OUTPUT
      - id: REFERENCE_SEQUENCE
        source: fasta_path
      - id: VALIDATION_STRINGENCY
        valueFrom: "LENIENT"
    out:
      - id: OUTPUT

  - id: picard_collectwgsmetrics
    run: ../../tools/picard_collectwgsmetrics.cwl
    in:
      - id: INPUT
        source: picard_markduplicates/OUTPUT
      - id: REFERENCE_SEQUENCE
        source: fasta_path
      - id: VALIDATION_STRINGENCY
        valueFrom: "LENIENT"
    out:
      - id: OUTPUT

  - id: samtools_flagstat
    run: ../../tools/samtools_flagstat.cwl
    in:
      - id: INPUT
        source: picard_markduplicates/OUTPUT
    out:
      - id: OUTPUT

  - id: samtools_idxstats
    run: ../../tools/samtools_idxstats.cwl
    in:
      - id: INPUT
        source: picard_markduplicates/OUTPUT
    out:
      - id: OUTPUT

  - id: samtools_stats
    run: ../../tools/samtools_stats.cwl
    in:
      - id: INPUT
        source: picard_markduplicates/OUTPUT
    out:
      - id: OUTPUT

  - id: picard_validatesamfile_original_to_sqlite
    run: ../../tools/picard_validatesamfile_to_sqlite.cwl
    in:
      - id: bam
        source: bam_path
        valueFrom: $(self.basename)
      - id: input_state
        valueFrom: alignment_last_step
      - id: metric_path
        source: picard_validatesamfile_original/OUTPUT
      - id: uuid
        source: uuid
    out:
      - id: log
      - id: sqlite

  - id: picard_markduplicates_to_sqlite
    run: ../../tools/picard_markduplicates_to_sqlite.cwl
    in:
      - id: bam
        source: bam_path
        valueFrom: $(self.basename)
      - id: input_state
        valueFrom: "markduplicates_readgroups"
      - id: metric_path
        source: picard_markduplicates/METRICS
      - id: uuid
        source: uuid
    out:
      - id: log
      - id: sqlite

  - id: picard_validatesamfile_markduplicates_to_sqlite
    run: ../../tools/picard_validatesamfile_to_sqlite.cwl
    in:
      - id: bam
        source: bam_path
        valueFrom: $(self.basename)
      - id: input_state
        valueFrom: "markduplicates_readgroups"
      - id: metric_path
        source: picard_validatesamfile_markduplicates/OUTPUT
      - id: uuid
        source: uuid
    out:
      - id: log
      - id: sqlite

  - id: picard_collectmultiplemetrics_to_sqlite
    run: ../../tools/picard_collectmultiplemetrics_to_sqlite.cwl
    in:
      - id: bam
        source: bam_path
        valueFrom: $(self.basename)
      - id: fasta
        source: fasta_path
        valueFrom: $(self.basename)
      - id: input_state
        valueFrom: "markduplicates_readgroups"
      - id: uuid
        source: uuid
      - id: vcf
        source: vcf_path
        valueFrom: $(self.basename)
      - id: alignment_summary_metrics
        source: picard_collectmultiplemetrics/alignment_summary_metrics
      - id: bait_bias_detail_metrics
        source: picard_collectmultiplemetrics/bait_bias_detail_metrics
      - id: bait_bias_summary_metrics
        source: picard_collectmultiplemetrics/bait_bias_summary_metrics
      - id: base_distribution_by_cycle_metrics
        source: picard_collectmultiplemetrics/base_distribution_by_cycle_metrics
      - id: gc_bias_detail_metrics
        source: picard_collectmultiplemetrics/gc_bias_detail_metrics
      - id: gc_bias_summary_metrics
        source: picard_collectmultiplemetrics/gc_bias_summary_metrics
      - id: insert_size_metrics
        source: picard_collectmultiplemetrics/insert_size_metrics
      - id: pre_adapter_detail_metrics
        source: picard_collectmultiplemetrics/pre_adapter_detail_metrics
      - id: pre_adapter_summary_metrics
        source: picard_collectmultiplemetrics/pre_adapter_summary_metrics
      - id: quality_by_cycle_metrics
        source: picard_collectmultiplemetrics/quality_by_cycle_metrics
      - id: quality_distribution_metrics
        source: picard_collectmultiplemetrics/quality_distribution_metrics
      - id: quality_yield_metrics
        source: picard_collectmultiplemetrics/quality_yield_metrics
    out:
      - id: log
      - id: sqlite

  - id: picard_collectoxogmetrics_to_sqlite
    run: ../../tools/picard_collectoxogmetrics_to_sqlite.cwl
    in:
    in:
      - id: bam
        source: bam_path
        valueFrom: $(self.basename)
      - id: fasta
        source: fasta_path
        valueFrom: $(self.basename)
      - id: input_state
        valueFrom: "markduplicates_readgroups"
      - id: metric_path
        source: picard_collectoxogmetrics/OUTPUT
      - id: uuid
        source: uuid
      - id: vcf
        source: vcf_path
        valueFrom: $(self.basename)
    out:
      - id: log
      - id: sqlite

  - id: picard_collectwgsmetrics_to_sqlite
    run: ../../tools/picard_collectwgsmetrics_to_sqlite.cwl
    in:
      - id: bam
        source: bam_path
        valueFrom: $(self.basename)
      - id: fasta
        source: fasta_path
        valueFrom: $(self.basename)
      - id: input_state
        valueFrom: "markduplicates_readgroups"
      - id: metric_path
        source: picard_collectwgsmetrics/OUTPUT
      - id: uuid
        source: uuid
    out:
      - id: log
      - id: sqlite

  - id: samtools_flagstat_to_sqlite
    run: ../../tools/samtools_flagstat_to_sqlite.cwl
    in:
      - id: bam
        source: bam_path
        valueFrom: $(self.basename)
      - id: input_state
        valueFrom: "markduplicates_readgroups"
      - id: metric_path
        source: samtools_flagstat/OUTPUT
      - id: uuid
        source: uuid
    out:
      - id: log
      - id: sqlite

  - id: samtools_idxstats_to_sqlite
    run: ../../tools/samtools_idxstats_to_sqlite.cwl
    in:
      - id: bam
        source: bam_path
        valueFrom: $(self.basename)
      - id: input_state
        valueFrom: "markduplicates_readgroups"
      - id: metric_path
        source: samtools_idxstats/OUTPUT
      - id: uuid
        source: uuid
    out:
      - id: log
      - id: sqlite

  - id: samtools_stats_to_sqlite
    run: ../../tools/samtools_stats_to_sqlite.cwl
    in:
      - id: bam
        source: bam_path
        valueFrom: $(self.basename)
      - id: input_state
        valueFrom: "markduplicates_readgroups"
      - id: metric_path
        source: samtools_stats/OUTPUT
      - id: uuid
        source: uuid
    out:
      - id: log
      - id: sqlite

  - id: integrity_workflow
    run: integrity_workflow.cwl
    in:
      - id: bai_path
        source: picard_markduplicates/OUTPUT
        valueFrom: $(self.secondaryFiles[0])
      - id: bam_path
        source: picard_markduplicates/OUTPUT
      - id: input_state
        valueFrom: "markduplicates_readgroups"
      - id: load_bucket
        source: load_bucket
      - id: uuid
        source: uuid
    out:
      - id: merge_sqlite_destination_sqlite

  - id: merge_all_sqlite
    run: ../../tools/merge_sqlite.cwl
    in:
      - id: source_sqlite
        source: [
        picard_validatesamfile_original_to_sqlite/sqlite,
        picard_markduplicates_to_sqlite/sqlite,
        picard_validatesamfile_markduplicates_to_sqlite/sqlite,
        picard_collectmultiplemetrics_to_sqlite/sqlite,
        picard_collectoxogmetrics_to_sqlite/sqlite,
        picard_collectwgsmetrics_to_sqlite/sqlite,
        samtools_idxstats_to_sqlite/sqlite,
        samtools_flagstat_to_sqlite/sqlite,
        samtools_stats_to_sqlite/sqlite,
        integrity_workflow/merge_sqlite_destination_sqlite
        ]
      - id: uuid
        source: uuid
    out:
      - id: destination_sqlite
      - id: log
