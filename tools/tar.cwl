#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/xz:b8f105f87b8d69a0414f8997bd5b586e502d9a1aa74d429314ec97cbddd81ff8
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: create
    type: boolean
    default: true
    inputBinding:
      prefix: --create
      position: 0

  - id: file
    type: string
    inputBinding:
      prefix: --file
      position: 1

  - id: xz
    type: boolean
    default: true
    inputBinding:
      prefix: --xz
      position: 2

  - id: INPUT
    type:
      type: array
      items: File
    inputBinding:
      position: 3

outputs:
  - id: OUTPUT
    type: File
    outputBinding:
      glob: $(inputs.file)

baseCommand: [tar]
