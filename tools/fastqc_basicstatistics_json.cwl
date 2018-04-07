#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/fastqc_to_json:4a955c8dd0078b129293a7603b24da5ded003ab148a6e2e86b5c1a574863c7e5
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 1000
    ramMax: 1000
    tmpdirMin: 1
    tmpdirMax: 1
    outdirMin: 1
    outdirMax: 1

class: CommandLineTool

inputs:
  - id: sqlite_path
    type: File
    inputBinding:
      prefix: --sqlite_path

outputs:
  - id: OUTPUT
    type: File
    format: "edam:format_3464"
    outputBinding:
      glob: "fastqc.json"

baseCommand: [/usr/local/bin/fastqc_to_json]
