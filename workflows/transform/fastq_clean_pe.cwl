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
    type: ../../tools/readgroup.yml#readgroup_fastq_pe_file
  job_uuid: string

outputs:
  output:
    type: ../../tools/readgroup.yml#readgroup_fastq_pe_file
    outputSource: emit_readgroup_fastq_pe_file/output
  sqlite:
    type: File
    outputSource: json_to_sqlite/sqlite

steps:
  fastq_cleaner_pe:
    run: ../../tools/fastq_cleaner_pe.cwl
    in:
      fastq1:
        source: input
        valueFrom: $(self.forward_fastq)
      fastq2:
        source: input
        valueFrom: $(self.reverse_fastq)
    out: [ cleaned_fastq1, cleaned_fastq2, result_json ]

  emit_readgroup_fastq_pe_file:
    run: ../../tools/emit_readgroup_fastq_pe_file.cwl
    in:
      forward_fastq: fastq_cleaner_pe/cleaned_fastq1
      reverse_fastq: fastq_cleaner_pe/cleaned_fastq2
      readgroup_meta:
        source: input
        valueFrom: $(self.readgroup_meta)
    out: [ output ]

  json_to_sqlite:
    run: ../../tools/json_to_sqlite.cwl
    in:
      input_json: fastq_cleaner_pe/result_json
      job_uuid: job_uuid
      table_name:
        valueFrom: "fastq_cleaner_pe"
    out: [ sqlite, log ]
