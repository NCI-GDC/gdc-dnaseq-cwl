#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: SchemaDefRequirement
    types:
      - $import: ../../tools/capture_kit.yml

inputs:
  bam: File
  capture_kit_set_file:
    type: ../../tools/capture_kit.yml#capture_kit_set_file
  fasta:
    type: File
    secondaryFiles:
      - .amb
      - .ann
      - .bwt
      - .fai
      - .pac
      - .sa
      - ^.dict
  input_state: string
  job_uuid: string

outputs:
  sqlite:
    type: File
    outputSource: picard_collecthsmetrics_to_sqlite/sqlite

steps:
  picard_collecthsmetrics:
    run: ../../tools/picard_collecthsmetrics.cwl
    in:
      BAIT_INTERVALS:
        source: capture_kit_set_file
        valueFrom: $(self.capture_kit_bait_file)
      INPUT: bam
      OUTPUT:
        source: bam
        valueFrom: $(self.basename).hsmetrics
      REFERENCE_SEQUENCE: fasta
      TARGET_INTERVALS:
        source: capture_kit_set_file
        valueFrom: $(self.capture_kit_target_file)
    out: [ METRIC_OUTPUT ]

  picard_collecthsmetrics_to_sqlite:
    run: ../../tools/picard_collecthsmetrics_to_sqlite.cwl
    in:
      bam:
        source: bam
        valueFrom: $(self.basename)
      input_state: input_state
      metric_path: picard_collecthsmetrics/METRIC_OUTPUT
      job_uuid: job_uuid
    out: [ log, sqlite ]
