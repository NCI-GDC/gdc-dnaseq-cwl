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
  bam:
    type: File
    secondaryFiles:
      - ^.bai
  amplicon_kit_set_file_list:
    type:
      type: array
      items: ../../tools/amplicon_kit.yml#amplicon_kit_set_file
  capture_kit_set_file_list:
    type:
      type: array
      items: ../../tools/capture_kit.yml#capture_kit_set_file
  common_biallelic_vcf:
    type: File
    secondaryFiles:
      - .tbi
  fasta:
    type: File
    secondaryFiles:
      - .amb
      - .ann
      - .bwt
      - .fai
      - .pac
      - .sa
      - ^.dict
  input_state: string
  job_uuid: string
  known_snp:
    type: File
    secondaryFiles:
      - .tbi

outputs:
  sqlite:
    type: File
    outputSource: merge_sqlite/destination_sqlite

steps:
  amplicon_metrics:
    run: amplicon_metrics.cwl
    scatter: amplicon_kit_set_file
    in:
      bam: bam
      amplicon_kit_set_file: amplicon_kit_set_file_list
      fasta: fasta
      input_state: input_state
      job_uuid: job_uuid
    out: [ sqlite ]

  exome_metrics:
    run: exome_metrics.cwl
    scatter: capture_kit_set_file
    in:
      bam: bam
      capture_kit_set_file: capture_kit_set_file_list
      fasta: fasta
      input_state: input_state
      job_uuid: job_uuid
    out: [ sqlite ]

  merge_exome_sqlite:
    run: ../../tools/merge_sqlite.cwl
    in:
      source_sqlite: exome_metrics/sqlite
      job_uuid: job_uuid
    out: [ destination_sqlite, log ]

  merge_amplicon_sqlite:
    run: ../../tools/merge_sqlite.cwl
    in:
      source_sqlite: amplicon_metrics/sqlite
      job_uuid: job_uuid
    out: [ destination_sqlite, log ]

  gatk_getpileupsummaries:
    run: ../../tools/gatk4_getpileupsummaries.cwl
    in:
      input: bam
      variant: common_biallelic_vcf
    out: [ output ]

  gatk_calculatecontamination:
    run: ../../tools/gatk4_calculatecontamination.cwl
    in:
      input: gatk_getpileupsummaries/output
      bam_nameroot:
        source: bam
        valueFrom: $(self.nameroot)
    out: [ output ]

  gatk_calculatecontamination_to_sqlite:
    run: ../../tools/gatk_calculatecontamination_to_sqlite.cwl
    in:
      bam:
        source: bam
        valueFrom: $(self.basename)
      input_state: input_state
      job_uuid: job_uuid
      metric_path: gatk_calculatecontamination/output
    out: [ sqlite ]

  gatk_collectmultiplemetrics:
    run: ../../tools/gatk4_collectmultiplemetrics.cwl
    in:
      DB_SNP: known_snp
      INPUT: bam
      REFERENCE_SEQUENCE: fasta
    out: [ alignment_summary_metrics, bait_bias_detail_metrics, bait_bias_summary_metrics, base_distribution_by_cycle_metrics,
           gc_bias_detail_metrics, gc_bias_summary_metrics, insert_size_metrics, pre_adapter_detail_metrics, pre_adapter_summary_metrics,
           quality_by_cycle_metrics, quality_distribution_metrics, quality_yield_metrics ]

  gatk_collectmultiplemetrics_to_sqlite:
    run: ../../tools/picard_collectmultiplemetrics_to_sqlite.cwl
    in:
      bam:
        source: bam
        valueFrom: $(self.basename)
      fasta:
        source: fasta
        valueFrom: $(self.basename)
      input_state: input_state
      job_uuid: job_uuid
      vcf:
        source: known_snp
        valueFrom: $(self.basename)
      alignment_summary_metrics: gatk_collectmultiplemetrics/alignment_summary_metrics
      bait_bias_detail_metrics: gatk_collectmultiplemetrics/bait_bias_detail_metrics
      bait_bias_summary_metrics: gatk_collectmultiplemetrics/bait_bias_summary_metrics
      base_distribution_by_cycle_metrics: gatk_collectmultiplemetrics/base_distribution_by_cycle_metrics
      gc_bias_detail_metrics: gatk_collectmultiplemetrics/gc_bias_detail_metrics
      gc_bias_summary_metrics: gatk_collectmultiplemetrics/gc_bias_summary_metrics
      insert_size_metrics: gatk_collectmultiplemetrics/insert_size_metrics
      pre_adapter_detail_metrics: gatk_collectmultiplemetrics/pre_adapter_detail_metrics
      pre_adapter_summary_metrics: gatk_collectmultiplemetrics/pre_adapter_summary_metrics
      quality_by_cycle_metrics: gatk_collectmultiplemetrics/quality_by_cycle_metrics
      quality_distribution_metrics: gatk_collectmultiplemetrics/quality_distribution_metrics
      quality_yield_metrics: gatk_collectmultiplemetrics/quality_yield_metrics
    out: [ log, sqlite ]

  picard_collectoxogmetrics:
    run: ../../tools/picard_collectoxogmetrics.cwl
    in:
      DB_SNP: known_snp
      INPUT: bam
      REFERENCE_SEQUENCE: fasta
    out: [ OUTPUT ]

  picard_collectoxogmetrics_to_sqlite:
    run: ../../tools/picard_collectoxogmetrics_to_sqlite.cwl
    in:
      bam:
        source: bam
        valueFrom: $(self.basename)
      fasta:
        source: fasta
        valueFrom: $(self.basename)
      input_state: input_state
      metric_path: picard_collectoxogmetrics/OUTPUT
      job_uuid: job_uuid
      vcf:
        source: known_snp
        valueFrom: $(self.basename)
    out: [ log, sqlite ]

  picard_collectwgsmetrics:
    run: ../../tools/picard_collectwgsmetrics.cwl
    in:
      INPUT: bam
      REFERENCE_SEQUENCE: fasta
    out: [ OUTPUT ]

  picard_collectwgsmetrics_to_sqlite:
    run: ../../tools/picard_collectwgsmetrics_to_sqlite.cwl
    in:
      bam:
        source: bam
        valueFrom: $(self.basename)
      fasta:
        source: fasta
        valueFrom: $(self.basename)
      input_state: input_state
      metric_path: picard_collectwgsmetrics/OUTPUT
      job_uuid: job_uuid
    out: [ log, sqlite ]

  samtools_flagstat:
    run: ../../tools/samtools_flagstat.cwl
    in:
      INPUT: bam
    out: [ OUTPUT ]

  samtools_flagstat_to_sqlite:
    run: ../../tools/samtools_flagstat_to_sqlite.cwl
    in:
      bam:
        source: bam
        valueFrom: $(self.basename)
      input_state: input_state
      metric_path: samtools_flagstat/OUTPUT
      job_uuid: job_uuid
    out: [ sqlite ]

  samtools_idxstats:
    run: ../../tools/samtools_idxstats.cwl
    in:
      INPUT: bam
    out: [ OUTPUT ]

  samtools_idxstats_to_sqlite:
    run: ../../tools/samtools_idxstats_to_sqlite.cwl
    in:
      bam:
        source: bam
        valueFrom: $(self.basename)
      input_state: input_state
      metric_path: samtools_idxstats/OUTPUT
      job_uuid: job_uuid
    out: [ sqlite ]

  samtools_stats:
    run: ../../tools/samtools_stats.cwl
    in:
      INPUT: bam
    out: [ OUTPUT ]

  samtools_stats_to_sqlite:
    run: ../../tools/samtools_stats_to_sqlite.cwl
    in:
      bam:
        source: bam
        valueFrom: $(self.basename)
      input_state: input_state
      metric_path: samtools_stats/OUTPUT
      job_uuid: job_uuid
    out: [ sqlite ]

  merge_sqlite:
    run: ../../tools/merge_sqlite.cwl
    in:
      source_sqlite:
        source: [
          gatk_calculatecontamination_to_sqlite/sqlite,
          merge_exome_sqlite/destination_sqlite,
          merge_amplicon_sqlite/destination_sqlite,
          gatk_collectmultiplemetrics_to_sqlite/sqlite,
          picard_collectoxogmetrics_to_sqlite/sqlite,
          picard_collectwgsmetrics_to_sqlite/sqlite,
          samtools_flagstat_to_sqlite/sqlite,
          samtools_idxstats_to_sqlite/sqlite,
          samtools_stats_to_sqlite/sqlite
        ]
      job_uuid: job_uuid
    out: [ destination_sqlite, log ]
