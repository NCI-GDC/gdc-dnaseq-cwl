#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: ScatterFeatureRequirement

inputs:
  - id: input_file
    type:
      type: array
      items: File
  - id: known_indel
    type: File
  - id: known_snp
    type: File
  - id: reference_sequence
    type: File
  - id: num_threads
    type: int
  - id: uuid
    type: string
    
outputs:
  - id: gatk_printreads_output_bam
    type:
      type: array
      items: File
    source: gatk_printreads/output_bam
    
steps:
  - id: gatk_realignertargetcreator
    run: ../../tools/gatk_realignertargetcreator.cwl
    in:
      - id: input_file
        source: input_file
      - id: known
        source: known_indel
      - id: log_to_file
        valueFrom: $(uuid + "_rtc.log")
      - id: num_threads
        source: num_threads
      - id: out
        valueFrom: $(uuid + ".intervals")
      - id: reference_sequence
        source: reference_sequence
    out:
      - id: output_intervals

  - id: gatk_indelrealigner
    run: ../../tools/gatk_indelrealigner.cwl
    in:
      - id: input_file
        source: input_file
      - id: knownAlleles
        source: known_indel
      - id: log_to_file
        valueFrom: $(uuid + "_ir.log")
      - id: num_threads
        source: num_threads
      - id: reference_sequence
        source: reference_sequence
      - id: target_intervals
        source: gatk_realignertargetcreator/output_intervals
    out:
      - id: output_bam

  - id: gatk_baserecalibrator
    run: ../../tools/gatk_baserecalibrator.cwl
    scatter: gatk_baserecalibrator/bam_path
    inputs:
      - id: input_file
        source: gatk_indelrealigner/output_bam
      - id: knownSites
        source: known_snp
      - id: log_to_file
        valueFrom: $(uuid + "_bqsr.log")
      - id: num_cpu_threads_per_data_thread
        source: num_threads
      - id: reference_sequence
        source: reference_sequence
    outputs:
      - id: output_grp

  - id: sort_bqsr_grp
    run: ../../tools/sort_bqsr_grp.cwl
    inputs:
      - id: input_grp
        source: gatk_baserecalibrator/output_grp
    outputs:
      - id: output_grp

  - id: gatk_printreads
    run: ../../tools/gatk_printreads.cwl
    scatter: [gatk_indelrealigner/output_bam, sort_bqsr_grp/output_grp]
    scatterMethod: "dotproduct"
    inputs:
      - id: BQSR
        source: sort_bqsr_grp/output_grp
      - id: input_file
        source: gatk_baserecalibrator/output_bam
      - id: log_to_file
        valueFrom: $(uuid + "_pr.log")
      - id: num_cpu_threads_per_data_thread
        source: num_thread
      - id: reference_sequence
        source: reference_sequence
    outputs:
      - id: output_bam
