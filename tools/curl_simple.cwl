#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/curl:d27480e7ac07e583146362d59f48254c2f59dfaa023212d12e091e136a52bcdf
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
