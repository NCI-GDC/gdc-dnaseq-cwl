#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: fedora:29

class: CommandLineTool

inputs:
  - id: INPUT
    type: string

outputs:
  - id: OUTPUT
    type: File
    outputBinding:
      glob: $(inputs.INPUT).bam

stdout: $(inputs.INPUT).bam

baseCommand: [echo]
