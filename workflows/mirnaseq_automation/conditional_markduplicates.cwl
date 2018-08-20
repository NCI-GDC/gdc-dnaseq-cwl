#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement

inputs:
  - id: bam
    type: File
  - id: job_uuid
    type: string

outputs:
  - id: output
    type: File
    outputSource: picard_markduplicates/OUTPUT
  - id: sqlite
    type: File
    outputSource: picard_markduplicates_to_sqlite/sqlite

steps:
  - id: picard_markduplicates
    run: ../../tools/picard_markduplicates.cwl
    in:
      - id: INPUT
        source: bam
    out:
      - id: OUTPUT
      - id: METRICS

  - id: picard_markduplicates_to_sqlite
    run: ../../tools/picard_markduplicates_to_sqlite.cwl
    in:
      - id: bam
        source: bam
        valueFrom: $(self.basename)
      - id: input_state
        valueFrom: "markduplicates_readgroups"
      - id: metric_path
        source: picard_markduplicates/METRICS
      - id: job_uuid
        source: job_uuid
    out:
      - id: sqlite
