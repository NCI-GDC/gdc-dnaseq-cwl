#!/usr/bin/env cwl-runner
$namespaces:
  edam: "http://edamontology.org/"
cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement

inputs:
  bam: File
  thread_count: long

outputs:
  output:
    type: File
    outputSource: samtools_index/output
  sqlite:
    type: File
    outputSource: format_sqlite/output

steps:
  samtools_index:
    run: ../../tools/samtools_index.cwl
    in:
      input: bam
      thread_count: thread_count
    out: [ output ]

  empty_sqlite:
    run: ../../tools/touch.cwl
    in:
      input:
        valueFrom: "empty.sqlite"
    out: [ output ]

  format_sqlite:
    run: ../../tools/emit_file_format.cwl
    in:
      input: empty_sqlite/output
      format:
        valueFrom: "edam:format_2572"
    out: [ output ]
