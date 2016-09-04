#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement

inputs:
  - id: bam
    type: File
  - id: db_snp_vcf
    type: File
  - id: fasta
    type: File
  - id: input_state
    type: string
  - id: parent_bam
    type: string
  - id: thread_count
    type: int
  - id: uuid
    type: string

outputs:
  - id: merge_sqlite_destination_sqlite
    type: File
    outputSource: merge_sqlite/destination_sqlite

steps:
  - id: get_bam_readgroups
    run: ../../tools/get_bam_readgroups.cwl
    in:
      - id: bam
        source: bam
    out:
      - id: readgroups

  - id: get_bam_library
    run: ../../tools/get_bam_library.cwl
    in:
      - id: readgroups
        source: get_bam_readgroups/readgroups
    out:
      - id: library

  - id: get_bam_exome_kit
    run: ../../tools/get_bam_exome_kit.cwl
    in:
      - id: bam
        source: parent_bam
      - id: library
        source: get_bam_library/library
    out:
      - id: exome_kit

  - id: get_bait_target
    run: ../../tools/get_bait_target.cwl
    in:
      - id: exome_kit
        source: get_bam_exome_kit/exome_kit
    out:
      - id: bait
      - id: target

  - id: picard_collecthsmetrics
    run: ../../tools/picard_collecthsmetrics.cwl
    in:
      - id: BAIT_INTERVALS
        source: get_bait_target/bait
      - id: INPUT
        source: bam
      - id: OUTPUT
        source: bam
        valueFrom: $(self.basename + ".metrics")
      - id: REFERNCE_SEQUENCE
        source: fasta
      - id: TARGET_INTERVALS
        source: get_bait_target/target
    out:
      - id: METRIC_OUTPUT

  - id: picard_collecthsmetrics_to_sqlite
    run: ../../tools/picard_collecthsmetrics_to_sqlite.cwl
    in:
      - id: bam
        source: bam
        valueFrom: $(self.basename)
      - id: bam_library
        source: get_bam_library/library
      - id: exome_kit
        source: get_bam_exome_kit/exome_kit
      - id: fasta
        source: fasta
        valueFrom: $(self.basename)
      - id: input_state
        source: input_state
      - id: metric_path
        source: picard_collecthsmetrics/METRIC_OUTPUT
      - id: uuid
        source: uuid
    out:
      - id: log
      - id: sqlite

  - id: picard_collectmultiplemetrics
    run: ../../tools/picard_collectmultiplemetrics.cwl
    in:
      - id: DB_SNP
        source: db_snp_vcf
      - id: INPUT
        source: bam
      - id: REFERENCE_SEQUENCE
        source: fasta
    out:
      - id: OUTPUT

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
      - id: metric_path
        source: picard_collectmultiplemetrics/OUTPUT
      - id: uuid
        source: uuid
      - id: vcf
        source: db_snp_vcf
        valueFrom: $(self.basename)
    out:
      - id: log
      - id: sqlite

  - id: picard_collectoxogmetrics
    run: ../../tools/picard_collectoxogmetrics.cwl
    in:
      - id: DB_SNP
        source: db_snp_vcf
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
      - id: uuid
        source: uuid
      - id: vcf
        source: db_snp_vcf
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
      - id: uuid
        source: uuid
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
      - id: uuid
        source: uuid
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
      - id: uuid
        source: uuid
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
      - id: uuid
        source: uuid
    out:
      - id: sqlite

  - id: merge_sqlite
    run: ../../tools/merge_sqlite.cwl
    in:
      - id: source_sqlite
        source: [
          picard_collecthsmetrics_to_sqlite/sqlite,
          picard_collectmultiplemetrics_to_sqlite/sqlite,
          picard_collectoxogmetrics_to_sqlite/sqlite,
          picard_collectwgsmetrics_to_sqlite/sqlite,
          samtools_flagstat_to_sqlite/sqlite,
          samtools_idxstats_to_sqlite/sqlite,
          samtools_stats_to_sqlite/sqlite
        ]
      - id: uuid
        source: uuid
    out:
      - id: destination_sqlite
      - id: log
