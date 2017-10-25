#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/picard_metrics_sqlite:5593d5980f3246972c80bab23bb26f714519a48ae95fcb6d4f5eb56441df146a
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: bam
    type: string
    inputBinding:
      prefix: --bam

  - id: fasta
    type: string
    inputBinding:
      prefix: --fasta

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

  - id: vcf
    type: string
    inputBinding:
      prefix: --vcf

outputs:
  - id: log
    type: File
    outputBinding:
      glob: $(inputs.task_uuid+"_picard_CollectOxoGMetrics.log")

  - id: sqlite
    type: File
    outputBinding:
      glob: $(inputs.task_uuid + ".db")
          
baseCommand: [/usr/local/bin/picard_metrics_sqlite, --metric_name, CollectOxoGMetrics]
