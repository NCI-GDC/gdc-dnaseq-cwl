#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: ubuntu:artful-20171019
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: input
    type: File
    inputBinding:
      position: 0

outputs:
  - id: fasta
    type: File
    outputBinding:
      glob: "*.fa"

baseCommand: [tar, xf]
