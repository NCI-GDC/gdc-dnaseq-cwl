#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/json-to-sqlite:43564cbca5b19e99d5d4ebf28987cde30facd6082854086967617fbe6be641eb

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
