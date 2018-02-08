#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - $import: ../../tools/readgroup_no_pu.yaml
  - class: InlineJavascriptRequirement
  - class: MultipleInputFeatureRequirement
  - class: ScatterFeatureRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  - id: bam_name
    type: string
  - id: bioclient_config
    type: File
  - id: readgroup_pe_uuids
    type: 
      type: array
      items: ../../tools/readgroup_no_pu.yaml#readgroup_pe_uuid
  - id: readgroup_se_uuids
    type: 
      type: array
      items: ../../tools/readgroup_no_pu.yaml#readgroup_se_uuid
  - id: bam_record_uuids
    type: 
      type: array
      items: ../../tools/readgroup_no_pu.yaml#bam_record_uuid

outputs:
  - id: output_bam
    type: File
    outputSource: picard_mergesamfiles/MERGED_OUTPUT

steps:
  - id: fastqtosam_pe
    run: fastqtosam_pe.cwl
    scatter: [readgroup_pe_uuid]
    in:
      - id: bioclient_config
        source: bioclient_config
      - id: readgroup_pe_uuid
        source: readgroup_pe_uuids
    out:
      - id: output_bam

  - id: fastqtosam_se
    run: fastqtosam_se.cwl
    scatter: [readgroup_se_uuid]
    in:
      - id: bioclient_config
        source: bioclient_config
      - id: readgroup_se_uuid
        source: readgroup_se_uuids
    out:
      - id: output_bam

  - id: bamtobam
    run: bamtobam.cwl
    scatter: [bam_record_uuid]
    in:
      - id: bioclient_config
        source: bioclient_config
      - id: bam_record_uuid
        source: bam_record_uuids
    out:
      - id: output_bam

  - id: picard_mergesamfiles_pe
    run: ../../tools/picard_mergesamfiles.cwl
    in:
      - id: INPUT
        source: fastqtosam_pe/output_bam
      - id: OUTPUT
        valueFrom:  $(bam_name.slice(0,-4)).pe.bam
    out:
      - id: MERGED_OUTPUT

  - id: picard_mergesamfiles_se
    run: ../../tools/picard_mergesamfiles.cwl
    in:
      - id: INPUT
        source: fastqtosam_se/output_bam
      - id: OUTPUT
        valueFrom:  $(bam_name.slice(0,-4)).se.bam
    out:
      - id: MERGED_OUTPUT

  - id: picard_mergesamfiles_bam
    run: ../../tools/picard_mergesamfiles.cwl
    in:
      - id: INPUT
        source: fastqtosam_se/output_bam
      - id: OUTPUT
        valueFrom:  $(bam_name).bam
    out:
      - id: MERGED_OUTPUT

  - id: picard_mergesamfiles
    run: ../../tools/picard_mergesamfiles.cwl
    in:
      - id: INPUT
        source: [
        picard_mergesamfiles_bam/MERGED_OUTPUT,
        picard_mergesamfiles_pe/MERGED_OUTPUT,
        picard_mergesamfiles_se/MERGED_OUTPUT
        ]
      - id: OUTPUT
        source: bam_name
    out:
      - id: MERGED_OUTPUT
