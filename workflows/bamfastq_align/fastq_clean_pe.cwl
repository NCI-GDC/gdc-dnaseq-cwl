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
    type: ../../tools/readgroup.yml#readgroup_fastq_pe_file

outputs:
  - id: output
    type: ../../tools/readgroup.yml#readgroup_fastq_pe_file
    outputSource: emit_readgroup_fastq_pe_file/output

steps:
  - id: fastq_cleaner_pe
    run: ../../tools/fastq_cleaner_pe.cwl
    in:
      - id: fastq1
        source: input
        valueFrom: $(self.forward_fastq)
      - id: fastq2
        source: input
        valueFrom: $(self.reverse_fastq)
    out:
      - id: cleaned_fastq1
      - id: cleaned_fastq2

  - id: emit_readgroup_fastq_pe_file
    run: ../../tools/emit_readgroup_fastq_pe_file.cwl
    in:
      - id: forward_fastq
        source: fastq_cleaner_pe/cleaned_fastq1
      - id: reverse_fastq
        source: fastq_cleaner_pe/cleaned_fastq2
      - id: readgroup_meta
        source: input
        valueFrom: $(self.readgroup_meta)
    out:
      - id: output
