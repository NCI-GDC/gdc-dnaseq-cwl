#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: SchemaDefRequirement
    types:
      - $import: ../../tools/capture_kit.yml

inputs:
  - id: bam
    type: File
  - id: capture_kit_set
    type: ../../tools/capture_kit.yml#capture_kit_set
  - id: fasta
    type: File
  - id: input_state
    type: string
  - id: job_uuid
    type: string

outputs:
  - id: sqlite
    type: File
    outputSource: picard_collecthsmetrics_to_sqlite/sqlite

steps:
  - id: picard_collecthsmetrics
    run: ../../tools/picard_collecthsmetrics.cwl
    in:
      - id: BAIT_INTERVALS
        source: capture_kit_set
        valueFrom: $(self.capture_kit_bait_file)
      - id: INPUT
        source: bam
      - id: OUTPUT
        valueFrom: $(bam.basename).hsmetrics
      - id: REFERENCE_SEQUENCE
        source: fasta
      - id: TARGET_INTERVALS
        source: capture_kit_set
        valueFrom: $(self.capture_kit_target_file)
    out:
      - id: METRIC_OUTPUT

  - id: picard_collecthsmetrics_to_sqlite
    run: ../../tools/picard_collecthsmetrics_to_sqlite.cwl
    in:
      - id: bam
        source: bam
        valueFrom: $(self.basename)
      - id: input_state
        source: input_state
      - id: metric_path
        source: picard_collecthsmetrics/METRIC_OUTPUT
      - id: job_uuid
        source: job_uuid
    out:
      - id: log
      - id: sqlite
