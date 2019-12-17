cwlVersion: v1.0
class: Workflow
id: gdc_dnaseq_metrics_wf
requirements:
  - class: InlineJavascriptRequirement
  - class: SchemaDefRequirement
    types:
      - $import: ../../tools/target_kit_schema.yml
  - class: SubworkflowFeatureRequirement

inputs:
  bam:
    type: File
    secondaryFiles:
      - ^.bai
  amplicon_kit_set_file_list:
    type:
      type: array
      items: ../../tools/target_kit_schema.yml#amplicon_kit_set_file
  capture_kit_set_file_list:
    type:
      type: array
      items: ../../tools/target_kit_schema.yml#capture_kit_set_file
  collect_wgs_metrics: long[]
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
  thread_count: long

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
      reference: fasta
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

  picard_collectoxogmetrics:
    run: ../../tools/picard_collectoxogmetrics.cwl
    in:
      DB_SNP: known_snp
      INPUT: bam
      REFERENCE_SEQUENCE: fasta
      CONTEXTS:
        default: ["CCG"]
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

  wgs_metrics:
    run: wgs_metrics.cwl
    scatter: run_wgs 
    in:
      bam: bam
      run_wgs: collect_wgs_metrics
      fasta: fasta
      input_state: input_state
      job_uuid: job_uuid
    out: [ sqlite ]

  merge_wgs_sqlite:
    run: ../../tools/merge_sqlite.cwl
    in:
      source_sqlite: wgs_metrics/sqlite
      job_uuid: job_uuid
    out: [ destination_sqlite, log ]

  samtools_flagstat:
    run: ../../tools/samtools_flagstat.cwl
    in:
      INPUT: bam
      threads: thread_count
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
      threads: thread_count
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
          merge_wgs_sqlite/destination_sqlite,
          picard_collectoxogmetrics_to_sqlite/sqlite,
          samtools_flagstat_to_sqlite/sqlite,
          samtools_idxstats_to_sqlite/sqlite,
          samtools_stats_to_sqlite/sqlite
        ]
      job_uuid: job_uuid
    out: [ destination_sqlite, log ]
