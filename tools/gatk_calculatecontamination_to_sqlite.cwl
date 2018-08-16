#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/picard_metrics_sqlite:d60d360e5ef990963aadce8ae77de3e4e1476ec4ecb115eb3064e27c9516e5a3
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

  - id: input_state
    type: string
    inputBinding:
      prefix: --input_state

  - id: job_uuid
    type: string
    inputBinding:
      prefix: --job_uuid

  - id: metric_path
    type: File
    inputBinding:
      prefix: --metric_path

outputs:
  - id: log
    type: File
    outputBinding:
      glob: $(inputs.job_uuid+"_picard_gatk_CalculateContamination.log")

  - id: sqlite
    format: "edam:format_3621"
    type: File
    outputBinding:
      glob: $(inputs.job_uuid + ".db")

baseCommand: [/usr/local/bin/picard_metrics_sqlite, --metric_name, gatk_CalculateContamination]
