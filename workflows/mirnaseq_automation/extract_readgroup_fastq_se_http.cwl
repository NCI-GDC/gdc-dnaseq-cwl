#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: ScatterFeatureRequirement
  - class: SchemaDefRequirement
    types:
      - $import: ../../tools/readgroup.yml
  - class: StepInputExpressionRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  - id: gdc_token
    type: File
  - id: readgroup_fastq_se_uuid
    type: ../../tools/readgroup.yml#readgroup_fastq_se_uuid

outputs:
  - id: output
    type: ../../tools/readgroup.yml#readgroup_fastq_se_file
    outputSource: emit_readgroup_fastq_se_file/output

steps:
  - id: extract_fastq
    run: ../../tools/gdc_get_object.cwl
    in:
      - id: gdc_token
        source: gdc_token
      - id: gdc_uuid
        source: readgroup_fastq_se_uuid
        valueFrom: $(self.forward_fastq_uuid)
      - id: file_size
        source: readgroup_fastq_se_uuid
        valueFrom: $(self.forward_fastq_file_size)
    out:
      - id: output
      
  - id: emit_readgroup_fastq_se_file
    run: ../../tools/emit_readgroup_fastq_se_file.cwl
    in:
      - id: fastq
        source: extract_fastq/output
      - id: readgroup_meta
        source: readgroup_fastq_se_uuid
        valueFrom: $(self.readgroup_meta)
    out:
      - id: output
