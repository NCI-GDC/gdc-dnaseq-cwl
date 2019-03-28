#!/usr/bin/env cwl-runner
$namespaces:
  edam: "http://edamontology.org/"
cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement

inputs:
  - id: bam
    type: File
  - id: thread_count
    type: long

outputs:
  - id: output
    type: File
    outputSource: samtools_index/output
  - id: sqlite
    type: File
    outputSource: format_sqlite/output

steps:
  - id: samtools_index
    run: ../../tools/samtools_index.cwl
    in:
      - id: input
        source: bam
      - id: thread_count
        source: thread_count
    out:
      - id: output

  - id: empty_sqlite
    run: ../../tools/touch.cwl
    in:
      - id: input
        valueFrom: "empty.sqlite"
    out:
      - id: output

  - id: format_sqlite
    run: ../../tools/emit_file_format.cwl
    in:
      - id: input
        source: empty_sqlite/output
      - id: format
        valueFrom: "edam:format_2572"
    out:
      - id: output
