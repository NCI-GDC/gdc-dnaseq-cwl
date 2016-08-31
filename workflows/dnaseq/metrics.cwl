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

outputs: []

steps:
  - id: picard_collectalignmentsummarymetrics_original
    run: ../../tools/picard_collectalignmentsummarymetrics.cwl.yaml
    inputs:
      - id: INPUT
        source: bam_path
      - id: VALIDATION_STRINGENCY
        valueFrom: "LENIENT"
    outputs:
      - id: OUTPUT

  - id: picard_collectalignmentsummarymetrics_markduplicates
    run: ../../tools/picard_collectalignmentsummarymetrics.cwl.yaml
    inputs:
      - id: INPUT
        source: picard_markduplicates/OUTPUT
      - id: REFERENCE_SEQUENCE
        source: reference_fasta_path
    outputs:
      - id: OUTPUT

  - id: picard_collectmultiplemetrics
    run: ../../tools/picard_collectmultiplemetrics.cwl.yaml
    scatter: picard_collectmultiplemetrics/INPUT
    inputs:
      - id: INPUT
        source: picard_sortsam/OUTPUT
      - id: REFERENCE_SEQUENCE
        source: reference_fasta_path
    outputs:
      - id: OUTPUT

  - id: picard_collectmultiplemetrics_to_sqlite
    run: ../../tools/picard_collectmultiplemetrics_to_sqlite.cwl.yaml
    scatter: [picard_collectmultiplemetrics/INPUT, picard_collectmultiplemetrics/OUTPUT]
    in:
      - id: bam
        source: picard_collectmultiplemetrics/INPUT
        valueFrom: $(self.basename)
      - id: fasta
        source: reference_fasta_path
        valueFrom: $(self.basename)
      - id: input_state
        valueFrom: input_state
      - id: metric_path
        source: picard_collectmultiplemetrics/OUTPUT
      - id: uuid
        source: uuid
      - id: vcf
        source: vcf_path
        valueFrom: $(self.basename)
    out:
      - id: log
      - id: sqlite

  - id: merge_picard_collectmultiplemetrics_sqlite
    run: ../../tools/merge_sqlite.cwl.yaml
    inputs:
      - id: source_sqlite
        source: picard_collectmultiplemetrics_to_sqlite/sqlite
      - id: uuid
        source: uuid
    outputs:
      - id: destination_sqlite
      - id: log

  - id: picard_collectoxogmetrics
    run: ../../tools/picard_collectoxogmetrics.cwl.yaml
    scatter: "#picard_collectoxogmetrics/bam_path"
    inputs:
      - id: bam_path
        source: "#picard_sortsam/output_bam"
      - id: db_snp_path
        source: "#db_snp_path"
      - id: input_state
        default: input_state
      - id: reference_fasta_path
        source: "#reference_fasta_path"
      - id: uuid
        source: "#uuid"
    outputs:
      - id: log
      - id: output_sqlite

  - id: merge_picard_collectoxogmetrics_sqlite
    run: ../../tools/merge_sqlite.cwl.yaml
    inputs:
      - id: source_sqlite
        source: "#picard_collectoxogmetrics/output_sqlite"
      - id: uuid
        source: "#uuid"
    outputs:
      - id: destination_sqlite
      - id: log

  - id: readgroup_json_db
    run: ../../tools/readgroup_json_db.cwl.yaml
    scatter: readgroup_json_db/json_path
    in:
      - id: json_path
        source: bam_readgroup_to_json/OUTPUT
      - id: uuid
        source: uuid
    out:
      - id: log
      - id: output_sqlite

  - id: merge_readgroup_json_db_sqlite
    run: ../../tools/merge_sqlite.cwl.yaml
    in:
      - id: source_sqlite
        source: readgroup_json_db/output_sqlite
      - id: uuid
        source: uuid
    out:
      - id: destination_sqlite
      - id: log


  - id: merge_all_sqlite
    run: ../../tools/merge_sqlite.cwl.yaml
    inputs:
      - id: source_sqlite
        source: [
          merge_bwa_pe_sqlite/destination_sqlite
          merge_picard_sortsam_sqlite/destination_sqlite
          merge_picard_buildbamindex_sqlite/destination_sqlite
          merge_fastqc1_sqlite/destination_sqlite
          merge_fastqc_db1_sqlite/destination_sqlite
          merge_fastqc2_sqlite/destination_sqlite
          merge_fastqc_db2_sqlite/destination_sqlite
          merge_readgroup_json_db_sqlite/destination_sqlite
          merge_samtools_flagstat_sqlite/destination_sqlite
          merge_samtools_stats_sqlite/destination_sqlite
          merge_picard_collectmultiplemetrics_sqlite/destination_sqlite
          merge_picard_collectoxogmetrics_sqlite/destination_sqlite
        ]
      - id: uuid
        source: uuid
    outputs:
      - id: destination_sqlite
      - id: log
