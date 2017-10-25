#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/samtools_metrics_sqlite:284177e619045d3f176c12462ffde23a5d4377aeec9a5ffe3e63f8ba61ef14b6
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: bam
    type: string
    inputBinding:
      prefix: --bam

  - id: input_state
    type: string
    inputBinding:
      prefix: --input_state

  - id: metric_path
    type: File
    inputBinding:
      prefix: --metric_path

  - id: task_uuid
    type: string
    inputBinding:
      prefix: --task_uuid

outputs:
  - id: log
    type: File
    outputBinding:
      glob: $(inputs.task_uuid+"_samtools_stats.log")

  - id: sqlite
    type: File
    outputBinding:
      glob: $(inputs.task_uuid + ".db")

baseCommand: [/usr/local/bin/samtools_metrics_sqlite, --metric_name, stats]
