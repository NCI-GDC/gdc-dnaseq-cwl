#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/json-to-sqlite:40352c0efc65926b772f9f96252faad809741a1abcd324a8a232f33fd3d31ecf
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 1000
    ramMax: 1000
    tmpdirMin: 10
    tmpdirMax: 10
    outdirMin: 10
    outdirMax: 10

class: CommandLineTool

inputs:
  - id: input_json
    type: File
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
