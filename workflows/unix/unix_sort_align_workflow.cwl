#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: ScatterFeatureRequirement
  - class: StepInputExpressionRequirement

inputs:
  - id: bam_path
    type: File
outputs:
  - id: output_bam
    type: File
    outputSource: merge/MERGED_OUTPUT

steps:
  - id: bamtoreadgroup
    run: unix_bamreadgroup_cmd.cwl
    in:
      - id: bam_path
        source: bam_path
    out:
      - id: output_readgroup

  - id: sort_readgroup
    run: ../../tools/sort_scatter_expression.cwl
    in:
      - id: INPUT
        source: bamtoreadgroup/output_readgroup
    out:
      - id: OUTPUT

  - id: bamtofastq
    run: unix_bamtofastq_cmd.cwl
    in:
      - id: bam_path
        source: bam_path
    out:
      - id: output_fastq1
      - id: output_fastq2


  - id: sort_fastq1
    run: ../../tools/sort_scatter_expression.cwl
    in:
      - id: INPUT
        source: bamtofastq/output_fastq1
    out:
      - id: OUTPUT

  - id: sort_fastq2
    run: ../../tools/sort_scatter_expression.cwl
    in:
      - id: INPUT
        source: bamtofastq/output_fastq2
    out:
      - id: OUTPUT

  - id: align
    run: unix_align_cmd.cwl
    scatter: [align/fastq1_path, align/fastq2_path, align/readgroup_path]
    scatterMethod: "dotproduct"
    in:
      - id: fastq1_path
        source: sort_fastq1/OUTPUT
      - id: fastq2_path
        source: sort_fastq2/OUTPUT
      - id: readgroup_path
        source: sort_readgroup/OUTPUT
    out:
      - id: output_bam

  - id: merge
    run: unix_merge_cmd.cwl
    in:
      - id: INPUT
        source: align/output_bam
      - id: OUTPUT
        source: bam_path
        valueFrom: $(self.basename)
    out:
      - id: MERGED_OUTPUT
