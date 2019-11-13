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
  input:
    type: ../../tools/readgroup.yml#readgroup_fastq_se_file
  job_uuid: string

outputs:
  output:
    type: ../../tools/readgroup.yml#readgroup_fastq_se_file
    outputSource: emit_readgroup_fastq_se_file/output
  sqlite:
    type: File
    outputSource: json_to_sqlite/sqlite

steps:
  fastq_cleaner_se:
    run: ../../tools/fastq_cleaner_se.cwl
    in:
      fastq:
        source: input
        valueFrom: $(self.fastq)
    out: [ cleaned_fastq, result_json ]

  emit_readgroup_fastq_se_file:
    run: ../../tools/emit_readgroup_fastq_se_file.cwl
    in:
      fastq: fastq_cleaner_se/cleaned_fastq
      readgroup_meta:
        source: input
        valueFrom: $(self.readgroup_meta)
    out: [ output ]

  json_to_sqlite:
    run: ../../tools/json_to_sqlite.cwl
    in:
      input_json: fastq_cleaner_se/result_json
      job_uuid: job_uuid
      table_name:
        valueFrom: "fastq_cleaner_se"
    out: [ sqlite, log ]
