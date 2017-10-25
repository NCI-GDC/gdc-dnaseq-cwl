#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: ubuntu:zesty-20170915
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: INPUT
    type: File
    inputBinding:
      position: 0

outputs:
  - id: OUTPUT
    type: File
    outputBinding:
      glob: $(inputs.INPUT.nameroot + ".ls")

stdout: $(inputs.INPUT.nameroot + ".ls")
      
baseCommand: [ls, -l]
