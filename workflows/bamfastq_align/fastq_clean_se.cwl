#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: InlineJavascriptRequirement
  - class: ScatterFeatureRequirement
  - class: SchemaDefRequirement
    types:
      - $import: ../../tools/readgroup.yml

class: Workflow

inputs:
  - id: input
    type: ../../tools/readgroup.yml#readgroup_fastq_se_file
  - id: job_uuid
    type: string

outputs:
  - id: output
    type: ../../tools/readgroup.yml#readgroup_fastq_se_file
    outputSource: emit_readgroup_fastq_se_file/output
  - id: sqlite
    type: File
    outputSource: json_to_sqlite/sqlite

steps:
  - id: fastq_cleaner_se
    run: ../../tools/fastq_cleaner_se.cwl
    in:
      - id: fastq
        source: input
        valueFrom: $(self.forward_fastq)
    out:
      - id: cleaned_fastq
      - id: result_json

  - id: emit_readgroup_fastq_se_file
    run: ../../tools/emit_readgroup_fastq_se_file.cwl
    in:
      - id: fastq
        source: fastq_cleaner_se/cleaned_fastq
      - id: readgroup_meta
        source: input
        valueFrom: $(self.readgroup_meta)
    out:
      - id: output

  - id: json_to_sqlite
    run: ../../tools/json_to_sqlite
    in:
      - id: input_json
        source: fastq_cleaner_se/result_json
      - id: job_uuid
        source: job_uuid
      - id: table_name
        valueFrom: "fastq_cleaner_se"
    out:
      - id: sqlite
      - id: log
