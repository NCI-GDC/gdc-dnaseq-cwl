#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: fedora:28

class: CommandLineTool

inputs:
  - id: INPUT
    type: File
    inputBinding:
      position: 1

  - id: PATTERN
    type: string
    inputBinding:
      position: 0

  - id: OUTFILE
    type: string

outputs:
  - id: OUTPUT
    type: File
    outputBinding:
      glob: $(inputs.OUTFILE)

stdout: $(inputs.OUTFILE)
      
baseCommand: [grep]
