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

outputs:
  - id: output
    type: ../../tools/readgroup.yml#readgroup_fastq_se_file
    outputSource: emit_readgroup_fastq_se_file/output

steps:
  - id: fastq_cleaner_se
    run: ../../tools/fastq_cleaner_se.cwl
    in:
      - id: fastq
        source: input
        valueFrom: $(self.fastq)
    out:
      - id: cleaned_fastq

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
