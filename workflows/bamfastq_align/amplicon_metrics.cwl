#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: SchemaDefRequirement
    types:
      - $import: ../../tools/amplicon_kit.yml

inputs:
  - id: bam
    type: File
  - id: amplicon_kit_set_file
    type: ../../tools/amplicon_kit.yml#amplicon_kit_set_file
  - id: fasta
    type: File
  - id: input_state
    type: string
  - id: job_uuid
    type: string

outputs:
  - id: sqlite
    type: File
    outputSource: picard_collecttargetedpcrmetrics_to_sqlite/sqlite

steps:
  - id: picard_collecttargetedpcrmetrics
    run: ../../tools/picard_collecttargetedpcrmetrics.cwl
    in:
      - id: AMPLICON_INTERVALS
        source: amplicon_kit_set_file
        valueFrom: $(self.amplicon_kit_amplicon_file)
      - id: INPUT
        source: bam
      - id: OUTPUT
        source: bam
        valueFrom: $(self.basename).pcrmetrics
      - id: REFERENCE_SEQUENCE
        source: fasta
      - id: TARGET_INTERVALS
        source: amplicon_kit_set_file
        valueFrom: $(self.amplicon_kit_target_file)
    out:
      - id: METRIC_OUTPUT

  - id: picard_collecttargetedpcrmetrics_to_sqlite
    run: ../../tools/picard_collecttargetedpcrmetrics_to_sqlite.cwl
    in:
      - id: bam
        source: bam
        valueFrom: $(self.basename)
      - id: input_state
        source: input_state
      - id: metric_path
        source: picard_collecttargetedpcrmetrics/METRIC_OUTPUT
      - id: job_uuid
        source: job_uuid
    out:
      - id: log
      - id: sqlite
