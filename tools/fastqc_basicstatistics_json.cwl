#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/fastqc_to_json:fa854aaa5b7735cf2821cd69280704e892bc0849b45f75d1bc206bbd44f7df3f

class: CommandLineTool

inputs:
  - id: sqlite_path
    type: File
    inputBinding:
      prefix: --sqlite_path

outputs:
  - id: OUTPUT
    type: File
    outputBinding:
      glob: "fastqc.json"

baseCommand: [/usr/local/bin/fastqc_to_json]
