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

  - id: bam_library
    type: File
    inputBinding:
      loadContents: true
      prefix: --bam_library
      valueFrom: $(self.contents.slice(0,-1))

  - id: exome_kit
    type: File
    inputBinding:
      loadContents: true
      prefix: --exome_kit
      valueFrom: $(self.contents.slice(0,-1))

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

  - id: uuid
    type: string
    inputBinding:
      prefix: --uuid

outputs:
  - id: log
    type: File
    outputBinding:
      glob: $(inputs.uuid+"_picard_CollectHsMetrics.log")

  - id: sqlite
    type: File
    outputBinding:
      glob: $(inputs.uuid + ".db")

baseCommand: [/usr/local/bin/picard_metrics_sqlite, --metric_name, CollectHsMetrics]
