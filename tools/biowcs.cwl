#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool
requirements:
  - class: DockerRequirement
    dockerPull: biowcs
  - class: InlineJavascriptRequirement

inputs:
  - id: env
    type: File
    inputBinding:
      prefix: -c

  - id: tdfs
    type: Directory
    default: "."
    inputBinding:
      prefix: --tdfs

  - id: pipeline
    type: File
    inputBinding:
      prefix: --pipeline

  - id: mode
    type: string
    inputBinding:
      prefix: --mode
      default: prod

  - id: no-send
    type: boolean
    default: True

outputs:
  - id: output
    type: File
    outputBinding:
      glob: $(inputs.pipeline.basename).stdout

  - id: stderr
    type: File
    outputBinding:
      glob: $(inputs.pipeline.basename).stderr

stdout: $(inputs.pipeline).stdout

stderr: $(inputs.pipeline).stderr
baseCommand: [/usr/local/bin/biowcs/]
