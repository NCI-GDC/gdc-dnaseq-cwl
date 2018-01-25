#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: StepInputExpressionRequirement

inputs:
  - id: fastq_1
    type: File
  - id: fastq_2
    type: File
  - id: read_group_json
    type: File

outputs:
  - id: output_bam
    type: File
    outputSource: picard_fastqtosam_pe/OUTPUT

steps:
  - id: emit_CN
    run: ../../tools/emit_json_value.cwl
    in:
      - id: input
        source: read_group_json
      - id: key
        valueFrom: CN
    out:
      - id: output
    
  - id: emit_DT
    run: ../../tools/emit_json_value.cwl
    in:
      - id: input
        source: read_group_json
      - id: key
        valueFrom: DT
    out:
      - id: output
    
  - id: emit_ID
    run: ../../tools/emit_json_value.cwl
    in:
      - id: input
        source: read_group_json
      - id: key
        valueFrom: ID
    out:
      - id: output
    
  - id: emit_LB
    run: ../../tools/emit_json_value.cwl
    in:
      - id: input
        source: read_group_json
      - id: key
        valueFrom: LB
    out:
      - id: output
    
  - id: emit_PL
    run: ../../tools/emit_json_value.cwl
    in:
      - id: input
        source: read_group_json
      - id: key
        valueFrom: PL
    out:
      - id: output
    
  - id: emit_PU
    run: ../../tools/emit_json_value.cwl
    in:
      - id: input
        source: read_group_json
      - id: key
        valueFrom: PU
    out:
      - id: output
    
  - id: emit_SM
    run: ../../tools/emit_json_value.cwl
    in:
      - id: input
        source: read_group_json
      - id: key
        valueFrom: SM
    out:
      - id: output
    
  - id: picard_fastqtosam_pe
    run: ../../tools/picard_fastqtosam_pe.cwl
    in:
      - id: FASTQ
        source: fastq_1
      - id: FASTQ2
        source: fastq_2
      - id: READ_GROUP_NAME
        source: emit_ID/output
      - id: SAMPLE_NAME
        source: emit_SM/output
      - id: LIBRARY_NAME
        source: emit_LB/output
      - id: PLATFORM_UNIT
        source: emit_PU/output
      - id: PLATFORM
        source: emit_PL/output
      - id: SEQUENCING_CENTER
        source: emit_CN/output
      - id: RUN_DATE
        source: emit_DT/output
      # - id: MAX_RECORDS_IN_RAM
      #   valueFrom: 500000
      - id: CREATE_INDEX
        valueFrom: "false"
    out:
      - id: OUTPUT
