#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - $import: ../../tools/readgroup.yml

inputs:
  - id: fastq
    type: File
  - id: readgroup_json
    type: File

outputs:
  - id: output
    type: ../../tools/readgroup.yml#readgroup_fastq_se_file
    outputSource: emit_readgroup_fastq_se/output

steps:
  - id: emit_json_readgroup_meta
    run: ../../tools/emit_json_readgroup_meta.cwl
    in:
      - id: input
        source: readgroup_json
    out:
      - id: output

  - id: emit_readgroup_fastq_se
    run: ../../tools/emit_readgroup_fastq_se_file.cwl
    in:
      - id: fastq
        source: fastq
      - id: readgroup_meta
        source: emit_json_readgroup_meta/output
    out:
      - id: output
