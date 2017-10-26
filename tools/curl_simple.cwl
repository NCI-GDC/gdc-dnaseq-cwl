#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/curl:c37090fe49ce21554b7d0550455a93b5a4a1548e4eea8c071414d8af5991c5fe
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
