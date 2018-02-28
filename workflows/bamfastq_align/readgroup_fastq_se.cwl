#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: SchemaDefRequirement
    types:
      - $import: ../../tools/readgroup.yml

inputs:
  - id: fastq
    type: File
  - id: readgroup_json
    type: File
  - id: readgroup_meta_list
    type:
      type: array
      items: ../../tools/readgroup.yml#readgroup_meta

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

  - id: emit_capture_kit
    run: ../../tools/emit_readgroup_meta_with_capture_kit.cwl
    in:
      - id: readgroup_meta
        source: emit_json_readgroup_meta/output
      - id: readgroup_meta_list
        source: readgroup_meta_list
    out:
      - id: output

  - id: emit_readgroup_fastq_se
    run: ../../tools/emit_readgroup_fastq_se_file.cwl
    in:
      - id: fastq
        source: fastq
      - id: readgroup_meta
        source: emit_capture_kit/output
    out:
      - id: output
