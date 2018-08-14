#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/picard_metrics_sqlite:72056da8fd5cf95e1829740b261ee52b4f7c35a7f22faed9b6fb4ea3d0a601e7
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 1000
    ramMax: 1000
    tmpdirMin: 5
    tmpdirMax: 5
    outdirMin: 5
    outdirMax: 5

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

  - id: vcf
    type: string
    inputBinding:
      prefix: --vcf

outputs:
  - id: log
    type: File
    outputBinding:
      glob: $(inputs.job_uuid+"_picard_CollectOxoGMetrics.log")

  - id: sqlite
    format: "edam:format_3621"
    type: File
    outputBinding:
      glob: $(inputs.job_uuid + ".db")
          
baseCommand: [/usr/local/bin/picard_metrics_sqlite, --metric_name, CollectOxoGMetrics]
