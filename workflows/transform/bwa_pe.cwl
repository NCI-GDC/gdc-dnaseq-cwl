#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: ScatterFeatureRequirement
  - class: SchemaDefRequirement
    types:
      - $import: ../../tools/readgroup.yml
  - class: StepInputExpressionRequirement

inputs:
  job_uuid: string
  reference_sequence:
    type: File
    secondaryFiles:
      - .amb
      - .ann
      - .bwt
      - .fai
      - .pac
      - .sa
      - ^.dict
  readgroup_fastq_pe:
    type: ../../tools/readgroup.yml#readgroup_fastq_file
  thread_count: long

outputs:
  bam:
    type: File
    outputSource: bwa_pe/OUTPUT
  sqlite:
    type: File
    outputSource: merge_sqlite/destination_sqlite

steps:
  fastqc1:
    run: ../../tools/fastqc.cwl
    in:
      INPUT:
        source: readgroup_fastq_pe
        valueFrom: $(self.forward_fastq)
      threads: thread_count
    out: [ OUTPUT ]

  fastqc2:
    run: ../../tools/fastqc.cwl
    in:
      INPUT:
        source: readgroup_fastq_pe
        valueFrom: $(self.reverse_fastq)
      threads: thread_count
    out: [ OUTPUT ]

  fastqc_db1:
    run: ../../tools/fastqc_db.cwl
    in:
      INPUT: fastqc1/OUTPUT
      job_uuid: job_uuid
    out: [ LOG, OUTPUT ]

  fastqc_db2:
    run: ../../tools/fastqc_db.cwl
    in:
      INPUT: fastqc2/OUTPUT
      job_uuid: job_uuid
    out: [ LOG, OUTPUT ]

  fastqc_basicstats_json:
    run: ../../tools/fastqc_basicstatistics_json.cwl
    in:
      sqlite_path: fastqc_db1/OUTPUT
    out: [ OUTPUT ]

  bwa_pe:
    run: ../../tools/bwa_record_pe.cwl
    in:
      fasta: reference_sequence
      fastq1:
        source: readgroup_fastq_pe
        valueFrom: $(self.forward_fastq)
      fastq2:
        source: readgroup_fastq_pe
        valueFrom: $(self.reverse_fastq)
      fastqc_json_path: fastqc_basicstats_json/OUTPUT
      readgroup_meta:
        source: readgroup_fastq_pe
        valueFrom: $(self.readgroup_meta)
      thread_count: thread_count
    out: [ OUTPUT ]

  bam_readgroup_to_json:
    run: ../../tools/bam_readgroup_to_json.cwl
    in:
      INPUT: bwa_pe/OUTPUT
      MODE:
        valueFrom: "lenient"
    out: [ OUTPUT ]

  readgroup_json_db:
    run: ../../tools/readgroup_json_db.cwl
    scatter: json_path
    in:
      json_path: bam_readgroup_to_json/OUTPUT
      job_uuid: job_uuid
    out: [ log, output_sqlite ]

  merge_readgroup_json_db:
    run: ../../tools/merge_sqlite.cwl
    in:
      source_sqlite: readgroup_json_db/output_sqlite
      job_uuid: job_uuid
    out: [ destination_sqlite ]

  merge_sqlite:
    run: ../../tools/merge_sqlite.cwl
    in:
      source_sqlite:
        source: [
        fastqc_db1/OUTPUT,
        fastqc_db2/OUTPUT,
        merge_readgroup_json_db/destination_sqlite
        ]
      job_uuid: job_uuid
    out: [ destination_sqlite, log ]
