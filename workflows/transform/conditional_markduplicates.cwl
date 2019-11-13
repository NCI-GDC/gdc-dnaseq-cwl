#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement

inputs:
  bam: File
  job_uuid: string

outputs:
  output:
    type: File
    outputSource: picard_markduplicates/OUTPUT
  sqlite:
    type: File
    outputSource: picard_markduplicates_to_sqlite/sqlite

steps:
  picard_markduplicates:
    run: ../../tools/picard_markduplicates.cwl
    in:
      INPUT: bam
    out: [ OUTPUT, METRICS ]

  picard_markduplicates_to_sqlite:
    run: ../../tools/picard_markduplicates_to_sqlite.cwl
    in:
      bam:
        source: bam
        valueFrom: $(self.basename)
      input_state:
        valueFrom: "markduplicates_readgroups"
      metric_path: picard_markduplicates/METRICS
      job_uuid: job_uuid
    out: [ sqlite ]
