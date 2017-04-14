#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: debian
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: url
    type: string

outputs:
  - id: output
    type: File
    outputBinding:
      glob: $(inputs.url.split('/').slice(-1)[0])

arguments:
  - valueFrom: $(inputs.url.split('/').slice(-1)[0])
    position: 1
          
baseCommand: [touch]
