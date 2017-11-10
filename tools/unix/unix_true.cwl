#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: alpine
  - class: InlineJavascriptRequirement
  - class: ShellCommandRequirement

inputs:
  - id: input
    type: string
    inputBinding:
      position: 1

outputs:
  - id: output
    type: File
    outputBinding:
      glob: output.txt

stdout: output.txt

baseCommand: echo
