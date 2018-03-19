#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: fedora:26
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1

class: CommandLineTool

inputs:
  - id: INPUT
    type: File
    inputBinding:
      position: 1

  - id: key
    type: string
    inputBinding:
      prefix: --key=
      separate: false

  - id: field-separator
    type: string
    default: " "
    inputBinding:
      prefix: --field-separator=
      separate: false

  - id: OUTFILE
    type: string

outputs:
  - id: OUTPUT
    type: File
    outputBinding:
      glob: $(inputs.OUTFILE)

stdout: $(inputs.OUTFILE)
      
baseCommand: [sort]
