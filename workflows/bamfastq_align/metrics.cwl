#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: SchemaDefRequirement
    types:
      - $import: ../../tools/amplicon_kit.yml
      - $import: ../../tools/capture_kit.yml
  - class: SubworkflowFeatureRequirement

inputs:
  - id: bam
    type: File
    secondaryFiles:
      - ^.bai
  - id: amplicon_kit_set_file_list
    type:
      type: array
      items: ../../tools/amplicon_kit.yml#amplicon_kit_set_file
  - id: capture_kit_set_file_list
    type:
      type: array
      items: ../../tools/capture_kit.yml#capture_kit_set_file
  - id: common_biallelic_vcf
    type: File
    secondaryFiles:
      - .tbi
  - id: fasta
    type: File
    secondaryFiles:
      - .amb
      - .ann
      - .bwt
      - .fai
      - .pac
      - .sa
      - ^.dict
  - id: input_state
    type: string
  - id: job_uuid
    type: string
  - id: known_snp
    type: File
    secondaryFiles:
      - .tbi

outputs:
  - id: sqlite
    type: File
    outputSource: merge_sqlite/destination_sqlite

steps:
  - id: amplicon_metrics
    run: amplicon_metrics.cwl
    scatter: amplicon_kit_set_file
    in:
      - id: bam
        source: bam
      - id: amplicon_kit_set_file
        source: amplicon_kit_set_file_list
      - id: fasta
        source: fasta
      - id: input_state
        source: input_state
      - id: job_uuid
        source: job_uuid
    out:
      - id: sqlite

  - id: exome_metrics
    run: exome_metrics.cwl
    scatter: capture_kit_set_file
    in:
      - id: bam
        source: bam
      - id: capture_kit_set_file
        source: capture_kit_set_file_list
      - id: fasta
        source: fasta
      - id: input_state
        source: input_state
      - id: job_uuid
        source: job_uuid
    out:
      - id: sqlite

  - id: merge_exome_sqlite
    run: ../../tools/merge_sqlite.cwl
    in:
      - id: source_sqlite
        source: exome_metrics/sqlite
      - id: job_uuid
        source: job_uuid
    out:
      - id: destination_sqlite
      - id: log

  - id: merge_amplicon_sqlite
    run: ../../tools/merge_sqlite.cwl
    in:
      - id: source_sqlite
        source: amplicon_metrics/sqlite
      - id: job_uuid
        source: job_uuid
    out:
      - id: destination_sqlite
      - id: log

  - id: gatk_getpileupsummaries
    run: ../../tools/gatk4_getpileupsummaries.cwl
    in:
      - id: input
        source: bam
      - id: variant
        source: common_biallelic_vcf
    out:
      - id: output

  - id: gatk_calculatecontamination
    run: ../../tools/gatk4_calculatecontamination.cwl
    in:
      - id: input
        source: gatk_getpileupsummaries/output
      - id: bam_nameroot
        source: bam
        valueFrom: $(self.nameroot)
    out:
      - id: output

  - id: gatk_calculatecontamination_to_sqlite
    run: ../../tools/gatk_calculatecontamination_to_sqlite.cwl
    in:
      - id: bam
        source: bam
        valueFrom: $(self.basename)
      - id: input_state
        source: input_state
      - id: job_uuid
        source: job_uuid
      - id: metric_path
        source: gatk_calculatecontamination/output
    out:
      - id: sqlite

  - id: picard_collectmultiplemetrics
    run: ../../tools/picard_collectmultiplemetrics.cwl
    in:
      - id: DB_SNP
        source: known_snp
      - id: INPUT
        source: bam
      - id: REFERENCE_SEQUENCE
        source: fasta
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

  - id: picard_collectmultiplemetrics_to_sqlite
    run: ../../tools/picard_collectmultiplemetrics_to_sqlite.cwl
    in:
      - id: bam
        source: bam
        valueFrom: $(self.basename)
      - id: fasta
        source: fasta
        valueFrom: $(self.basename)
      - id: input_state
        source: input_state
      - id: job_uuid
        source: job_uuid
      - id: vcf
        source: known_snp
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

  - id: picard_collectoxogmetrics
    run: ../../tools/picard_collectoxogmetrics.cwl
    in:
      - id: DB_SNP
        source: known_snp
      - id: INPUT
        source: bam
      - id: REFERENCE_SEQUENCE
        source: fasta
    out:
      - id: OUTPUT

  - id: picard_collectoxogmetrics_to_sqlite
    run: ../../tools/picard_collectoxogmetrics_to_sqlite.cwl
    in:
      - id: bam
        source: bam
        valueFrom: $(self.basename)
      - id: fasta
        source: fasta
        valueFrom: $(self.basename)
      - id: input_state
        source: input_state
      - id: metric_path
        source: picard_collectoxogmetrics/OUTPUT
      - id: job_uuid
        source: job_uuid
      - id: vcf
        source: known_snp
        valueFrom: $(self.basename)
    out:
      - id: log
      - id: sqlite

  - id: picard_collectwgsmetrics
    run: ../../tools/picard_collectwgsmetrics.cwl
    in:
      - id: INPUT
        source: bam
      - id: REFERENCE_SEQUENCE
        source: fasta
    out:
      - id: OUTPUT

  - id: picard_collectwgsmetrics_to_sqlite
    run: ../../tools/picard_collectwgsmetrics_to_sqlite.cwl
    in:
      - id: bam
        source: bam
        valueFrom: $(self.basename)
      - id: fasta
        source: fasta
        valueFrom: $(self.basename)
      - id: input_state
        source: input_state
      - id: metric_path
        source: picard_collectwgsmetrics/OUTPUT
      - id: job_uuid
        source: job_uuid
    out:
      - id: log
      - id: sqlite

  - id: samtools_flagstat
    run: ../../tools/samtools_flagstat.cwl
    in:
      - id: INPUT
        source: bam
    out:
      - id: OUTPUT

  - id: samtools_flagstat_to_sqlite
    run: ../../tools/samtools_flagstat_to_sqlite.cwl
    in:
      - id: bam
        source: bam
        valueFrom: $(self.basename)
      - id: input_state
        source: input_state
      - id: metric_path
        source: samtools_flagstat/OUTPUT
      - id: job_uuid
        source: job_uuid
    out:
      - id: sqlite

  - id: samtools_idxstats
    run: ../../tools/samtools_idxstats.cwl
    in:
      - id: INPUT
        source: bam
    out:
      - id: OUTPUT

  - id: samtools_idxstats_to_sqlite
    run: ../../tools/samtools_idxstats_to_sqlite.cwl
    in:
      - id: bam
        source: bam
        valueFrom: $(self.basename)
      - id: input_state
        source: input_state
      - id: metric_path
        source: samtools_idxstats/OUTPUT
      - id: job_uuid
        source: job_uuid
    out:
      - id: sqlite

  - id: samtools_stats
    run: ../../tools/samtools_stats.cwl
    in:
      - id: INPUT
        source: bam
    out:
      - id: OUTPUT

  - id: samtools_stats_to_sqlite
    run: ../../tools/samtools_stats_to_sqlite.cwl
    in:
      - id: bam
        source: bam
        valueFrom: $(self.basename)
      - id: input_state
        source: input_state
      - id: metric_path
        source: samtools_stats/OUTPUT
      - id: job_uuid
        source: job_uuid
    out:
      - id: sqlite

  - id: merge_sqlite
    run: ../../tools/merge_sqlite.cwl
    in:
      - id: source_sqlite
        source: [
          gatk_calculatecontamination_to_sqlite/sqlite,
          merge_exome_sqlite/destination_sqlite,
          merge_amplicon_sqlite/destination_sqlite,
          picard_collectmultiplemetrics_to_sqlite/sqlite,
          picard_collectoxogmetrics_to_sqlite/sqlite,
          picard_collectwgsmetrics_to_sqlite/sqlite,
          samtools_flagstat_to_sqlite/sqlite,
          samtools_idxstats_to_sqlite/sqlite,
          samtools_stats_to_sqlite/sqlite
        ]
      - id: job_uuid
        source: job_uuid
    out:
      - id: destination_sqlite
      - id: log
