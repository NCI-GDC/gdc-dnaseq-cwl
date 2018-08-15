#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/picard_metrics_sqlite:841670842bd14b04c02c4c39fbd1a79b5e04134ab706e48d458b98d165ac149f
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 1000
    ramMax: 1000
    tmpdirMin: 10
    tmpdirMax: 10
    outdirMin: 10
    outdirMax: 10

class: CommandLineTool

inputs:
  - id: bam
    type: string
    inputBinding:
      prefix: --bam

  - id: fasta
    type: ["null", string]
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
      glob: $(inputs.uuid+"_picard_CollectAlignmentSummaryMetrics.log")

  - id: sqlite
    format: "edam:format_3621"
    type: File
    outputBinding:
      glob: $(inputs.uuid + ".db")

baseCommand: [/usr/local/bin/picard_metrics_sqlite, --metric_name, CollectAlignmentSummaryMetrics]
