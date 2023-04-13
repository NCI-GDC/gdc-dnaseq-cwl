cwlVersion: v1.0
class: CommandLineTool
id: json_to_sqlite
requirements:
  - class: DockerRequirement
    dockerPull: "{{ docker_repo }}/json-to-sqlite:{{ json_to_sqlite }}"
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
    type: File
    outputBinding:
      glob: $(inputs.job_uuid).db

  log:
    type: File
    outputBinding:
      glob: $(inputs.job_uuid).log

baseCommand: [json_to_sqlite]
