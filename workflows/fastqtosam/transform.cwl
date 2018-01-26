#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: ScatterFeatureRequirement
  - class: StepInputExpressionRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  - id: bam_name
    type: string
  - id: fastq_1
    type:
      type: array
      items: File
  - id: fastq_2
    type:
      type: array
      items: File
  - id: fastq_s
    type:
      type: array
      items: File
  - id: read_groups
    type:
      type: array
      items: File

outputs:
  []
  # - id: output_bam
  #   type: File
  #   outputSource: picard_mergesamfiles/MERGED_OUTPUT

steps:
  - id: sort_scattered_fastq_1
    run: ../../tools/sort_scatter_expression.cwl
    in:
      - id: INPUT
        source: fastq_1
    out:
      - id: OUTPUT

  - id: sort_scattered_fastq_2
    run: ../../tools/sort_scatter_expression.cwl
    in:
      - id: INPUT
        source: fastq_2
    out:
      - id: OUTPUT

  - id: sort_scattered_fastq_s
    run: ../../tools/sort_scatter_expression.cwl
    in:
      - id: INPUT
        source: fastq_s
    out:
      - id: OUTPUT

  - id: decider_fastqtosam_pe
    run: ../../tools/decider_fastq_expression.cwl
    in:
      - id: fastq_path
        source: sort_scattered_fastq_1/OUTPUT
      - id: readgroup_path
        source: read_groups
    out:
      - id: output_readgroup_paths

  - id: decider_fastqtosam_se
    run: ../../tools/decider_fastq_expression.cwl
    in:
      - id: fastq_path
        source: sort_scattered_fastq_s/OUTPUT
      - id: readgroup_path
        source: read_groups
    out:
      - id: output_readgroup_paths

  - id: fastqtosam_pe
    run: fastqtosam_pe.cwl
    scatter: [fastq_1, fastq_2, read_group_json]
    scatterMethod: "dotproduct"
    in:
      - id: fastq_1
        source: sort_scattered_fastq_1/OUTPUT
      - id: fastq_2
        source: sort_scattered_fastq_2/OUTPUT
      - id: read_group_json
        source: decider_fastqtosam_pe/output_readgroup_paths
    out:
      - id: output_bam

  - id: fastqtosam_se
    run: fastqtosam_se.cwl
    scatter: [fastq_s, read_group_json]
    scatterMethod: "dotproduct"
    in:
      - id: fastq_s
        source: sort_scattered_fastq_s/OUTPUT
      - id: read_group_json
        source: decider_fastqtosam_se/output_readgroup_paths
    out:
      - id: output_bam

  - id: picard_mergesamfiles_pe
    run: ../../tools/picard_mergesamfiles.cwl
    in:
      - id: INPUT
        source: fastqtosam_pe/output_bam
      - id: OUTPUT
        source: bam_name
        valueFrom: $(self.slice(0,-4)).pe.bam
    out:
      - id: MERGED_OUTPUT

  - id: picard_mergesamfiles_se
    run: ../../tools/picard_mergesamfiles.cwl
    in:
      - id: INPUT
        source: fastqtosam_se/output_bam
      - id: OUTPUT
        source: bam_name
        valueFrom: $(self.slice(0,-4)).se.bam
    out:
      - id: MERGED_OUTPUT

  # - id: picard_mergesamfiles
  #   run: ../../tools/picard_mergesamfiles.cwl
  #   in:
  #     - id: INPUT
  #       source: [
  #       picard_mergesamfiles_pe/MERGED_OUTPUT,
  #       picard_mergesamfiles_se/MERGED_OUTPUT
  #       ]
  #     - id: OUTPUT
  #       source: input_bam
  #       valueFrom: $(self.basename.slice(0,-4) + "_gdc_ubam.bam")
  #   out:
  #     - id: MERGED_OUTPUT
