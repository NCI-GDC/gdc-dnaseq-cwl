#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: MultipleInputFeatureRequirement
  - class: ScatterFeatureRequirement
  - class: StepInputExpressionRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  - id: read_groups
    type:
      type: array
      items: File
  - id: fastq_1
    type:
      type: array
      items: File
  - id: fastq_2
    type:
      type: array
      items: File
  - id: fastq_2
    type:
      type: array
      items: File
  - id: thread_count
    type: long
  - id: job_uuid
    type: string

outputs:
  - id: output_bam
    type: File

steps:
  - id: sort_scattered_fastq1
    run: ../../tools/sort_scatter_expression.cwl
    in:
      - id: INPUT
        source: remove_duplicate_fastq1/OUTPUT
    out:
      - id: OUTPUT

  - id: sort_scattered_fastq2
    run: ../../tools/sort_scatter_expression.cwl
    in:
      - id: INPUT
        source: remove_duplicate_fastq2/OUTPUT
    out:
      - id: OUTPUT

  - id: sort_scattered_fastq_s
    run: ../../tools/sort_scatter_expression.cwl
    in:
      - id: INPUT
        source: remove_duplicate_fastq_s/OUTPUT
    out:
      - id: OUTPUT

  - id: decider_fastqtosam_pe
    run: ../../tools/decider_bwa_expression.cwl
    in:
      - id: fastq_path
        source: sort_scattered_fastq1/OUTPUT
      - id: readgroup_path
        source: bam_readgroup_to_json/OUTPUT
    out:
      - id: output_readgroup_paths

  - id: decider_fastqtosam_se
    run: ../../tools/decider_bwa_expression.cwl
    in:
      - id: fastq_path
        source: sort_scattered_fastq_s/OUTPUT
      - id: readgroup_path
        source: bam_readgroup_to_json/OUTPUT
    out:
      - id: output_readgroup_paths

  - id: fastqtosam_pe
    run: ../../tools/picard_fastqtosam.cwl
    scatter: [fastq1, fastq2, readgroup_json_path]
    scatterMethod: "dotproduct"
    in:
      - id: fasta
        source: reference_sequence
      - id: fastq1
        source: sort_scattered_fastq1/OUTPUT
      - id: fastq2
        source: sort_scattered_fastq2/OUTPUT
      - id: readgroup_json_path
        source: decider_bwa_pe/output_readgroup_paths
    out:
      - id: OUTPUT

  - id: fastqtosam_se
    run: ../../tools/picard_fastqtosam.cwl
    scatter: [fastq, readgroup_json_path]
    scatterMethod: "dotproduct"
    in:
      - id: fasta
        source: reference_sequence
      - id: fastq
        source: sort_scattered_fastq_s/OUTPUT
      - id: readgroup_json_path
        source: decider_bwa_se/output_readgroup_paths
    out:
      - id: OUTPUT

  - id: picard_mergesamfiles_pe
    run: ../../tools/picard_mergesamfiles.cwl
    in:
      - id: INPUT
        source: picard_sortsam_pe/SORTED_OUTPUT
      - id: OUTPUT
        source: input_bam
        valueFrom: $(self.basename)
    out:
      - id: MERGED_OUTPUT

  - id: picard_mergesamfiles_se
    run: ../../tools/picard_mergesamfiles.cwl
    in:
      - id: INPUT
        source: picard_sortsam_se/SORTED_OUTPUT
      - id: OUTPUT
        source: input_bam
        valueFrom: $(self.basename)
    out:
      - id: MERGED_OUTPUT

  - id: picard_mergesamfiles
    run: ../../tools/picard_mergesamfiles.cwl
    in:
      - id: INPUT
        source: [
        picard_mergesamfiles_pe/MERGED_OUTPUT,
        picard_mergesamfiles_se/MERGED_OUTPUT
        ]
      - id: OUTPUT
        source: input_bam
        valueFrom: $(self.basename.slice(0,-4) + "_gdc_ubam.bam")
    out:
      - id: MERGED_OUTPUT
