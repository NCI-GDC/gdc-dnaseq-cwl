#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/json-to-sqlite:b774a9093653e63d4c37d6747d95e4a58dbbd1417cab39d02ee776d50e7e3ac1

class: CommandLineTool

inputs:
  - id: input_json
    type: string
    inputBinding:
      prefix: --input_json

  - id: job_uuid
    type: string
    inputBinding:
      prefix: --job_uuid

  - id: table_name
    type: string
    inputBinding:
      prefix: --table_name

outputs:
  - id: sqlite
    type: File
    outputBinding:
      glob: $(inputs.job_uuid).db

  - id: log
    type: File
    outputBinding:
      glob: $(inputs.job_uuid).log

baseCommand: [json_to_sqlite]
