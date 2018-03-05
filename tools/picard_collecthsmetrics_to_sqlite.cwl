#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/picard_metrics_sqlite:a79eda28a26693ebefc7e7d99e0c5ae5435418a5352e436db4d55c824aa0beed
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

  - id: job_uuid
    type: string
    inputBinding:
      prefix: --job_uuid

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
