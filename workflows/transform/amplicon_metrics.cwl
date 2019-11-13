#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: SchemaDefRequirement
    types:
      - $import: ../../tools/amplicon_kit.yml

inputs:
  bam: File
  amplicon_kit_set_file:
    type: ../../tools/amplicon_kit.yml#amplicon_kit_set_file
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
    outputSource: picard_collecttargetedpcrmetrics_to_sqlite/sqlite

steps:
  picard_collecttargetedpcrmetrics:
    run: ../../tools/picard_collecttargetedpcrmetrics.cwl
    in:
      AMPLICON_INTERVALS:
        source: amplicon_kit_set_file
        valueFrom: $(self.amplicon_kit_amplicon_file)
      INPUT: bam
      OUTPUT:
        source: bam
        valueFrom: $(self.basename).pcrmetrics
      REFERENCE_SEQUENCE: fasta
      TARGET_INTERVALS:
        source: amplicon_kit_set_file
        valueFrom: $(self.amplicon_kit_target_file)
    out: [ METRIC_OUTPUT ]

  picard_collecttargetedpcrmetrics_to_sqlite:
    run: ../../tools/picard_collecttargetedpcrmetrics_to_sqlite.cwl
    in:
      bam:
        source: bam
        valueFrom: $(self.basename)
      input_state: input_state
      metric_path: picard_collecttargetedpcrmetrics/METRIC_OUTPUT
      job_uuid: job_uuid
    out: [ log, sqlite ]
