cwlVersion: v1.0
class: CommandLineTool
id: picard_collectwgsmetrics_to_sqlite
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/picard_metrics_sqlite:1.0.0
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

inputs:
  bam:
    type: string
    inputBinding:
      prefix: --bam

  fasta:
    type: string
    inputBinding:
      prefix: --fasta

  input_state:
    type: string
    inputBinding:
      prefix: --input_state

  metric_path:
    type: File
    inputBinding:
      prefix: --metric_path

  job_uuid:
    type: string
    inputBinding:
      prefix: --job_uuid

outputs:
  log:
    type: File
    outputBinding:
      glob: $(inputs.job_uuid+"_picard_CollectWgsMetrics.log")

  sqlite:
    type: File
    outputBinding:
      glob: $(inputs.job_uuid + ".db")

baseCommand: [--metric_name, CollectWgsMetrics]
