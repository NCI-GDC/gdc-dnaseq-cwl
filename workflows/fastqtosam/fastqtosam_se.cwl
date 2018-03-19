#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - $import: ../../tools/readgroup_no_pu.yaml
  - class: StepInputExpressionRequirement

inputs:
  - id: bioclient_config
    type: File
  - id: readgroup_fastq_se
    type: ../../tools/readgroup_no_pu.yaml#readgroup_fastq_se

outputs:
  - id: output_bam
    type: File
    outputSource: picard_fastqtosam_se/OUTPUT

steps:
  - id: extract_forward_fastq
    run: ../../tools/bio_client_download.cwl
    in:
      - id: config-file
        source: bioclient_config
      - id: download_handle
        source: readgroup_fastq_se
        valueFrom: $(self.forward_fastq_uuid)
      - id: file_size
        source: readgroup_fastq_se
        valueFrom: $(self.forward_fastq_file_size)
    out:
      - id: output

  - id: emit_pu
    run: ../../tools/fastq-to-sam-pu.cwl
    in:
      - id: fastq_path
        source: extract_forward_fastq/output
    out:
      - id: output

  - id: picard_fastqtosam_se
    run: ../../tools/picard_fastqtosam_se.cwl
    in:
      - id: FASTQ
        source: extract_forward_fastq/output
      - id: READ_GROUP_NAME
        source: readgroup_fastq_se
        valueFrom: $(self.readgroup_meta.ID)
      - id: SAMPLE_NAME
        source: readgroup_fastq_se
        valueFrom: $(self.readgroup_meta.SM)
      - id: LIBRARY_NAME
        source: readgroup_fastq_se
        valueFrom: $(self.readgroup_meta.LB)
      - id: PLATFORM_UNIT
        source: emit_pu/output
      - id: PLATFORM
        source: readgroup_fastq_se
        valueFrom: $(self.readgroup_meta.PL)
      - id: SEQUENCING_CENTER
        source: readgroup_fastq_se
        valueFrom: $(self.readgroup_meta.CN)
      - id: RUN_DATE
        source: readgroup_fastq_se
        valueFrom: $(self.readgroup_meta.DT)
      - id: MAX_RECORDS_IN_RAM
        default: 500000
      - id: CREATE_INDEX
        valueFrom: "false"
    out:
      - id: OUTPUT
