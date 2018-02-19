#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - $import: ../../tools/readgroup.yml
  - class: ScatterFeatureRequirement
  - class: StepInputExpressionRequirement

inputs:
  - id: job_uuid
    type: string
  - id: reference_sequence
    type: File
  - id: readgroup_fastq_pe
    type: ../../tools/readgroup.yml#readgroup_fastq_pe_file
  - id: thread_count
    type: long

outputs:
  - id: bam
    type: File
    outputSource: bwa_pe/OUTPUT
  - id: sqlite
    type: File
    outputSource: merge_sqlite/destination_sqlite

steps:
  - id: fastqc1
    run: ../../tools/fastqc.cwl
    in:
      - id: INPUT
        source: readgroup_fastq_pe
        valueFrom: $(self.forward_fastq)
      - id: threads
        source: thread_count
    out:
      - id: OUTPUT

  - id: fastqc2
    run: ../../tools/fastqc.cwl
    in:
      - id: INPUT
        source: readgroup_fastq_pe
        valueFrom: $(self.reverse_fastq)
      - id: threads
        source: thread_count
    out:
      - id: OUTPUT

  - id: fastqc_db1
    run: ../../tools/fastqc_db.cwl
    in:
      - id: INPUT
        source: fastqc1/OUTPUT
      - id: job_uuid
        source: job_uuid
    out:
      - id: LOG
      - id: OUTPUT

  - id: fastqc_db2
    run: ../../tools/fastqc_db.cwl
    in:
      - id: INPUT
        source: fastqc2/OUTPUT
      - id: job_uuid
        source: job_uuid
    out:
      - id: LOG
      - id: OUTPUT

  - id: fastqc_basicstats_json
    run: ../../tools/fastqc_basicstatistics_json.cwl
    in:
      - id: sqlite_path
        source: fastqc_db1/OUTPUT
    out:
      - id: OUTPUT

  - id: bwa_pe
    run: ../../tools/bwa_record_pe.cwl
    in:
      - id: fasta
        source: reference_sequence
      - id: fastq1
        source: readgroup_fastq_pe
        valueFrom: $(self.forward_fastq)
      - id: fastq2
        source: readgroup_fastq_pe
        valueFrom: $(self.reverse_fastq)
      - id: fastqc_json_path
        source: fastqc_basicstats_json/OUTPUT
      - id: readgroup_meta
        source: readgroup_fastq_pe
        valueFrom: $(self.fastq_meta)
      - id: thread_count
        source: thread_count
    out:
      - id: OUTPUT

  - id: bam_readgroup_to_json
    run: ../../tools/bam_readgroup_to_json.cwl
    in:
      - id: INPUT
        source: bwa_pe/OUTPUT
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
        fastqc_db1/OUTPUT,
        fastqc_db2/OUTPUT,
        merge_readgroup_json_db/destination_sqlite
        ]
      - id: job_uuid
        source: job_uuid
    out:
      - id: destination_sqlite
      - id: log
