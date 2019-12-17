cwlVersion: v1.0
class: CommandLineTool
id: samtools_flagstat_to_sqlite
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/samtools_metrics_sqlite:f64466282ce61dfc9251e7c32c5130928abf0a68c1f8e00b47d9709c5b3e3321
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 2000
    ramMax: 2000
    tmpdirMin: 5
    tmpdirMax: 5
    outdirMin: 5
    outdirMax: 5

inputs:
  bam:
    type: string
    inputBinding:
      prefix: --bam

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
      glob: $(inputs.job_uuid+"_samtools_flagstat.log")

  sqlite:
    format: "edam:format_3621"
    type: File
    outputBinding:
      glob: $(inputs.job_uuid + ".db")

baseCommand: [/usr/local/bin/samtools_metrics_sqlite, --metric_name, flagstat]
