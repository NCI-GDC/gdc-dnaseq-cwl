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
  - id: thread_count
    type: int
  - id: uuid
    type: string

outputs:
  - id: merge_sqlite_destination_sqlite
    type: File
    outputSource: merge_sqlite/destination_sqlite

steps:
  - id: picard_collectmultiplemetrics
    run: ../../tools/picard_collectmultiplemetrics.cwl
    inputs:
      - id: DB_SNP
        source: db_snp_vcf
      - id: INPUT
        source: bam
      - id: REFERENCE_SEQUENCE
        source: reference_fasta_path
    outputs:
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
    inputs:
      - id: DB_SNP
        source: bam
      - id: INPUT
        source: db_snp_vcf
      - id: REFERENCE_SEQUENCE
        source: fasta
    outputs:
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
    inputs:
      - id: DB_SNP
        source: bam
      - id: INPUT
        source: db_snp_vcf
      - id: REFERENCE_SEQUENCE
        source: fasta
    outputs:
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

  - id: readgroup_json_db
    run: ../../tools/readgroup_json_db.cwl
    in:
      - id: json_path
        source: bam_readgroup_to_json/OUTPUT
      - id: uuid
        source: uuid
    out:
      - id: log
      - id: output_sqlite

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
    inputs:
      - id: source_sqlite
        source: [
          picard_collectmultiplemetrics_to_sqlite/sqlite,
          picard_collectoxogmetrics_to_sqlite/sqlite,
          picard_collectwgsmetrics_to_sqlite/sqlite,
          readgroup_json_db/output_sqlite,
          samtools_flagstat_to_sqlite/sqlite,
          samtools_idxstats_to_sqlite/sqlite,
          samtools_stats_to_sqlite/sqlite
        ]
      - id: uuid
        source: uuid
    outputs:
      - id: destination_sqlite
      - id: log
