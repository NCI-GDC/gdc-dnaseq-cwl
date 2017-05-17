#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/curl:584c4fa535adf9d52d9e1284339494f2c93eceb16434230f4388052aeb5bc5e1
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
