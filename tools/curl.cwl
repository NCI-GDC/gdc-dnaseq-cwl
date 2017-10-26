#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/curl:c37090fe49ce21554b7d0550455a93b5a4a1548e4eea8c071414d8af5991c5fe
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: output
    type: string
    inputBinding:
      prefix: --output

  - id: url
    type: string
    inputBinding:
      prefix: --url

outputs:
  - id: output_file
    type: File
    outputBinding:
      glob: $(inputs.output)
      
baseCommand: [curl]
