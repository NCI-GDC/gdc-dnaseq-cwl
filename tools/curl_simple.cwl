#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/curl:c0a4eaf9b928f14db71fa28fcc928b602e74dbfd168a3d761a134b0ba5ec6d94
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
