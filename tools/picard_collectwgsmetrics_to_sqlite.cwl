#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/picard_metrics_sqlite:3cf06d97543ff4ad3dc404453ca34dd79cdd16bb2082be98a74a47a82cc638dd
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

  - id: job_uuid
    type: string
    inputBinding:
      prefix: --job_uuid

outputs:
  - id: log
    type: File
    outputBinding:
      glob: $(inputs.job_uuid+"_picard_CollectWgsMetrics.log")

  - id: sqlite
    type: File
    outputBinding:
      glob: $(inputs.job_uuid + ".db")

baseCommand: [/usr/local/bin/picard_metrics_sqlite, --metric_name, CollectWgsMetrics]
