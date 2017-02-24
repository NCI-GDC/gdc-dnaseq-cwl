#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/curl:1
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: url
    type: string
    inputBinding:
      prefix: --url

  - id: output
    type: string
    inputBinding:
      prefix: --output

outputs:
  - id: output_file
    type: File
    outputBinding:
      glob: $(inputs.output)
      
baseCommand: [curl]
