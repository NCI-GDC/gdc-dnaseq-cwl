#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/curl:584c4fa535adf9d52d9e1284339494f2c93eceb16434230f4388052aeb5bc5e1
  - class: InlineJavascriptRequirement

inputs:
  - id: url
    type: string
    inputBinding:
      position: 1

stdout: output

outputs:
  - id: output
    type: File
    outputBinding:
      glob: output

baseCommand: [curl]
