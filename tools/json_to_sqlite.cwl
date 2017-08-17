#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/json-to-sqlite:395d1b2079169f1746339dc2ff27ca648b0a67f31788142bcdda83ffbfeb19ca

class: CommandLineTool

inputs:
  - id: input_json
    type: string
    inputBinding:
      prefix: --input_json

  - id: run_uuid
    type: string
    inputBinding:
      prefix: --run_uuid

  - id: table_name
    type: string
    inputBinding:
      prefix: --table_name

outputs:
  - id: sqlite
    type: File
    outputBinding:
      glob: $(inputs.run_uuid).db

  - id: log
    type: File
    outputBinding:
      glob: $(inputs.run_uuid).log

baseCommand: [json_to_sqlite]
