#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

inputs:
  - id: fastq1_path
    type: File
  - id: fastq2_path
    type: File
  - id: readgroup_path
    type: File

outputs:
  - id: align_output
    type: File
    outputSource: align/output_bam

steps:
  - id: align
    run: unix_align_cmd.cwl
    in:
      - id: fastq1_path
        source: fastq1_path
      - id: fastq2_path
        source: fastq2_path
      - id: readgroup_path
        source: readgroup_path
    out:
      - id: output_bam
