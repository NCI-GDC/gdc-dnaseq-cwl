cwlVersion: v1.0
class: CommandLineTool
id: samtools_stats_to_sqlite
requirements:
  - class: DockerRequirement
    dockerPull: "{{ docker_repo }}/samtools_metrics_sqlite:{{ samtools_metrics_sqlite }}"
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
      glob: $(inputs.job_uuid+"_samtools_stats.log")

  sqlite:
    type: File
    outputBinding:
      glob: $(inputs.job_uuid + ".db")

baseCommand: [/usr/local/bin/samtools_metrics_sqlite, --metric_name, stats]
