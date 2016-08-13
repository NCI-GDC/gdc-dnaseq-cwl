#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: alpine
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.INPUT)
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: INPUT
    type: File

outputs:
  - id: OUTPUT
    type: File
    outputBinding:
      glob: $(inputs.INPUT.basename)
    secondaryFiles:
      - ^.bai

arguments:
  - valueFrom: $(inputs.INPUT.nameroot + ".bai")
    position: 0
          
baseCommand: [touch]
