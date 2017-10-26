#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/samtools_metrics_sqlite:45b161680b60ab2fcd2fab718632769b9a3329af376f11dac6f673e702f1df7e
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
      glob: $(inputs.task_uuid+"_samtools_idxstats.log")

  - id: sqlite
    type: File
    outputBinding:
      glob: $(inputs.task_uuid + ".db")

baseCommand: [/usr/local/bin/samtools_metrics_sqlite, --metric_name, idxstats]
