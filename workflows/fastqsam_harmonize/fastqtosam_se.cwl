#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - $import: ../../tools/readgroup_path.yaml
  - class: StepInputExpressionRequirement

inputs:
  - id: readgroup_fastq_pe
    type: ../../tools/readgroup_path.yaml#readgroup_fastq_se

outputs:
  - id: output_bam
    type: File
    outputSource: picard_fastqtosam_se/OUTPUT

steps:
  - id: emit_pu
    run: ../../tools/fastq-to-sam-pu.cwl
    in:
      - id: fastq_path
        source: readgroup_fastq_se
        valueFrom: $(self.forward_fastq)
    out:
      - id: output

  - id: picard_fastqtosam_se
    run: ../../tools/picard_fastqtosam_se.cwl
    in:
      - id: FASTQ
        source: extract_forward_fastq/output
      - id: READ_GROUP_NAME
        source: readgroup_fastq_pe
        valueFrom: $(self.readgroup_meta.ID)
      - id: SAMPLE_NAME
        source: readgroup_fastq_pe
        valueFrom: $(self.readgroup_meta.SM)
      - id: LIBRARY_NAME
        source: readgroup_fastq_pe
        valueFrom: $(self.readgroup_meta.LB)
      - id: PLATFORM_UNIT
        source: emit_pu/output
      - id: PLATFORM
        source: readgroup_fastq_pe
        valueFrom: $(self.readgroup_meta.PL)
      - id: SEQUENCING_CENTER
        source: readgroup_fastq_pe
        valueFrom: $(self.readgroup_meta.CN)
      - id: RUN_DATE
        source: readgroup_fastq_pe
        valueFrom: $(self.readgroup_meta.DT)
      - id: MAX_RECORDS_IN_RAM
        default: 500000
      - id: CREATE_INDEX
        valueFrom: "false"
    out:
      - id: OUTPUT
