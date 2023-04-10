cwlVersion: v1.0
class: CommandLineTool
id: gatk_calculatecontamination_to_sqlite
requirements:
  - class: DockerRequirement
    dockerPull: "{{ docker_repo }}/picard_metrics_sqlite:{{ picard_metrics_sqlite }}"
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

  input_state:
    type: string
    inputBinding:
      prefix: --input_state

  job_uuid:
    type: string
    inputBinding:
      prefix: --job_uuid

  metric_path:
    type: File
    inputBinding:
      prefix: --metric_path

outputs:
  log:
    type: File
    outputBinding:
      glob: $(inputs.job_uuid+"_picard_gatk_CalculateContamination.log")

  sqlite:
    type: File
    outputBinding:
      glob: $(inputs.job_uuid + ".db")

baseCommand: [--metric_name, gatk_CalculateContamination]
