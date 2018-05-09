#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: ubuntu:bionic-20180426
  - class: InitialWorkDirRequirement
    listing:
      - entryname: $(inputs.OUTNAME)
        entry: $(inputs.INPUT)
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: INPUT
    type: File

  - id: OUTNAME
    type: string

outputs:
  - id: OUTPUT
    type: File
    outputBinding:
      glob: $(inputs.OUTNAME)

baseCommand: [/bin/true]
