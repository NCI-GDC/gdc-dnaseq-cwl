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
  - id: readgroup_fastq_pe_list
    type: 
      type: array
      items: ../../tools/readgroup_no_pu.yaml#readgroup_fastq_pe
  - id: readgroup_fastq_se_list
    type: 
      type: array
      items: ../../tools/readgroup_no_pu.yaml#readgroup_fastq_se
  - id: readgroups_bam_list
    type: 
      type: array
      items: ../../tools/readgroup_no_pu.yaml#readgroups_bam

outputs:
  - id: output_bam
    type: File
    outputSource: picard_mergesamfiles/MERGED_OUTPUT

steps:
  - id: fastqtosam_pe
    run: fastqtosam_pe.cwl
    scatter: [readgroup_fastq_pe]
    in:
      - id: bioclient_config
        source: bioclient_config
      - id: readgroup_fastq_pe
        source: readgroup_fastq_pe_list
    out:
      - id: output_bam

  - id: fastqtosam_se
    run: fastqtosam_se.cwl
    scatter: [readgroup_fastq_se]
    in:
      - id: bioclient_config
        source: bioclient_config
      - id: readgroup_fastq_se
        source: readgroup_fastq_se_list
    out:
      - id: output_bam

  - id: bamtobam
    run: bamtobam.cwl
    scatter: [readgroups_bam]
    in:
      - id: bioclient_config
        source: bioclient_config
      - id: readgroups_bam
        source: readgroups_bam_list
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
