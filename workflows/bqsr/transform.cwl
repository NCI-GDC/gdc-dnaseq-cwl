#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement

inputs:
  - id: input_file
    type: File
  - id: known_snp
    type: File
  - id: reference_sequence
    type: File
  - id: num_threads
    type: int
  - id: run_uuid
    type: string
    
outputs:
  - id: gatk_printreads_output_bam
    type: File
    outputSource: gatk_printreads/output_bam
    
steps:
  - id: picard_buildbamindex
    run: ../../tools/picard_buildbamindex.cwl
    in:
      - id: INPUT
        source: input_file
      - id: VALIDATION_STRINGENCY
        valueFrom: "LENIENT"
    out:
      - id: OUTPUT

  - id: gatk_baserecalibrator
    run: ../../tools/gatk_baserecalibrator.cwl
    in:
      - id: input_file
        source: picard_buildbamindex/OUTPUT
      - id: knownSites
        source: known_snp
      - id: log_to_file
        source: run_uuid
        valueFrom: $(self + "_bqsr.log" )
      - id: num_cpu_threads_per_data_thread
        source: num_threads
      - id: reference_sequence
        source: reference_sequence
    out:
      - id: output_grp

  - id: gatk_printreads
    run: ../../tools/gatk_printreads.cwl
    in:
      - id: BQSR
        source: gatk_baserecalibrator/output_grp
      - id: input_file
        source: input_file
      - id: log_to_file
        source: run_uuid
        valueFrom: $(self + "_pr.log")
      - id: num_cpu_threads_per_data_thread
        source: num_threads
      - id: reference_sequence
        source: reference_sequence
    out:
      - id: output_bam
