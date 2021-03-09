cwlVersion: v1.0
class: CommandLineTool
id: json_to_sqlite
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/json-to-sqlite:439b1b7f41fedc927859177a8073ac8b9ab8179b9c474fc274ac415d95b6eb7c
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
  input_json:
    type: File
    inputBinding:
      prefix: --input_json

  job_uuid:
    type: string
    inputBinding:
      prefix: --job_uuid

  table_name:
    type: string
    inputBinding:
      prefix: --table_name

outputs:
  sqlite:
    format: "edam:format_3621"
    type: File
    outputBinding:
      glob: $(inputs.job_uuid).db

  log:
    type: File
    outputBinding:
      glob: $(inputs.job_uuid).log

baseCommand: [json_to_sqlite]
