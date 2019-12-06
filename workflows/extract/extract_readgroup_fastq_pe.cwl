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
  readgroup_fastq_pe_uuid:
    type: ../../tools/readgroup.yml#readgroup_fastq_uuid
  bioclient_config: File

outputs:
  output:
    type: ../../tools/readgroup.yml#readgroup_fastq_file
    outputSource: emit_readgroup_fastq_pe_file/output

steps:
  extract_forward_fastq:
    run: ../../tools/bio_client_download.cwl
    in:
      config-file: bioclient_config
      download_handle:
        source: readgroup_fastq_pe_uuid
        valueFrom: $(self.forward_fastq_uuid)
      file_size:
        source: readgroup_fastq_pe_uuid
        valueFrom: $(self.forward_fastq_file_size)
    out: [ output ]

  extract_reverse_fastq:
    run: ../../tools/bio_client_download.cwl
    in:
      config-file: bioclient_config
      download_handle:
        source: readgroup_fastq_pe_uuid
        valueFrom: $(self.reverse_fastq_uuid)
      file_size:
        source: readgroup_fastq_pe_uuid
        valueFrom: $(self.reverse_fastq_file_size)
    out: [ output ]

  emit_readgroup_fastq_pe_file:
    run: ../../tools/emit_readgroup_fastq_file.cwl
    in:
      forward_fastq: extract_forward_fastq/output
      reverse_fastq: extract_reverse_fastq/output
      readgroup_meta:
        source: readgroup_fastq_pe_uuid
        valueFrom: $(self.readgroup_meta)
    out: [ output ]
