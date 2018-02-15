#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - $import: ../../tools/readgroup_path.yaml
  - class: InlineJavascriptRequirement
  - class: MultipleInputFeatureRequirement
  - class: ScatterFeatureRequirement
  - class: StepInputExpressionRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  - id: readgroup_fastq_pe_path_list
    type:
      type: array
      items: ../../tools/readgroup_path.yaml#readgroup_fastq_pe
  - id: readgroup_fastq_se_path_list
    type:
      type: array
      items: ../../tools/readgroup_path.yaml#readgroup_fastq_se
  - id: readgroups_bam_path_list
    type:
      type: array
      items: ../../tools/readgroup_path.yaml#readgroups_bam

steps:
  - id: fastqtosam_pe
    run: fastqtosam_pe.cwl
    scatter: [readgroup_fastq_pe]
    in:
      - id: readgroup_fastq_pe
        source: readgroup_fastq_pe_list
    out:
      - id: output_bam

  - id: fastqtosam_se
    run: fastqtosam_se.cwl
    scatter: [readgroup_fastq_se]
    in:
      - id: readgroup_fastq_se
        source: readgroup_fastq_se_list
    out:
      - id: output_bam

  - id: bamtobam
    run: bamtobam.cwl
    scatter: [readgroups_bam]
    in:
      - id: readgroups_bam
        source: readgroups_bam_list
    out:
      - id: output_bam

  - id: picard_mergesamfiles_unaligned_pe
    run: ../../tools/picard_mergesamfiles.cwl
    in:
      - id: INPUT
        source: fastqtosam_pe/output_bam
      - id: OUTPUT
        source: bam_name
        valueFrom: $(self.slice(0,-4)).pe.bam
    out:
      - id: MERGED_OUTPUT

  - id: picard_mergesamfiles_unaligned_se
    run: ../../tools/picard_mergesamfiles.cwl
    in:
      - id: INPUT
        source: fastqtosam_se/output_bam
      - id: OUTPUT
        source: bam_name
        valueFrom: $(self.slice(0,-4)).se.bam
    out:
      - id: MERGED_OUTPUT

  - id: picard_mergesamfiles_unaligned_bam
    run: ../../tools/picard_mergesamfiles.cwl
    in:
      - id: INPUT
        source: bamtobam/output_bam
      - id: OUTPUT
        source: bam_name
        valueFrom: $(self).bam
    out:
      - id: MERGED_OUTPUT

  - id: picard_mergesamfiles_unaligned
    run: ../../tools/picard_mergesamfiles.cwl
    in:
      - id: INPUT
        source: [
        picard_mergesamfiles_unaligned_bam/MERGED_OUTPUT,
        picard_mergesamfiles_unaligned_pe/MERGED_OUTPUT,
        picard_mergesamfiles_unaligned_se/MERGED_OUTPUT
        ]
      - id: OUTPUT
        source: bam_name
    out:
      - id: MERGED_OUTPUT
