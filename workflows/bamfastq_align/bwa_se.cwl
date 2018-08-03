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
  - id: job_uuid
    type: string
  - id: reference_sequence
    type: File
    secondaryFiles:
      - .amb
      - .ann
      - .bwt
      - .fai
      - .pac
      - .sa
      - ^.dict
  - id: readgroup_fastq_se
    type: ../../tools/readgroup.yml#readgroup_fastq_se_file
  - id: thread_count
    type: long

outputs:
  - id: bam
    type: File
    outputSource: bwa_se/OUTPUT
  - id: sqlite
    type: File
    outputSource: merge_sqlite/destination_sqlite

steps:
  - id: fastq_cleaner
    run: ../../tools/fastq_cleaner_se.cwl
    in:
      - id: fastq
        source: readgroup_fastq_se
        valueFrom: $(self.fastq)
    out:
      - id: cleaned_fastq

  - id: fastqc
    run: ../../tools/fastqc.cwl
    in:
      - id: INPUT
        source: fastq_cleaner/cleaned_fastq
      - id: threads
        source: thread_count
    out:
      - id: OUTPUT

  - id: fastqc_db
    run: ../../tools/fastqc_db.cwl
    in:
      - id: INPUT
        source: fastqc/OUTPUT
      - id: job_uuid
        source: job_uuid
    out:
      - id: LOG
      - id: OUTPUT

  - id: fastqc_basicstats_json
    run: ../../tools/fastqc_basicstatistics_json.cwl
    in:
      - id: sqlite_path
        source: fastqc_db/OUTPUT
    out:
      - id: OUTPUT

  - id: bwa_se
    run: ../../tools/bwa_record_se.cwl
    in:
      - id: fasta
        source: reference_sequence
      - id: fastq
        source: fastq_cleaner/cleaned_fastq
      - id: fastqc_json_path
        source: fastqc_basicstats_json/OUTPUT
      - id: readgroup_meta
        source: readgroup_fastq_se
        valueFrom: $(self.readgroup_meta)
      - id: thread_count
        source: thread_count
    out:
      - id: OUTPUT

  - id: bam_readgroup_to_json
    run: ../../tools/bam_readgroup_to_json.cwl
    in:
      - id: INPUT
        source: bwa_se/OUTPUT
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
      - id: job_uuid
        source: job_uuid
    out:
      - id: log
      - id: output_sqlite

  - id: merge_readgroup_json_db
    run: ../../tools/merge_sqlite.cwl
    in:
      - id: source_sqlite
        source: readgroup_json_db/output_sqlite
      - id: job_uuid
        source: job_uuid
    out:
      - id: destination_sqlite

  - id: merge_sqlite
    run: ../../tools/merge_sqlite.cwl
    in:
      - id: source_sqlite
        source: [
        fastqc_db/OUTPUT,
        merge_readgroup_json_db/destination_sqlite
        ]
      - id: job_uuid
        source: job_uuid
    out:
      - id: destination_sqlite
      - id: log
