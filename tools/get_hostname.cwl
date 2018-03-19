#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 500
    ramMax: 500
    tmpdirMin: 1
    tmpdirMax: 1
    outdirMin: 1
    outdirMax: 1

class: CommandLineTool

inputs:
  []

outputs:
  - id: output
    type: File
    outputBinding:
      glob: output

stdout: output

baseCommand: [bash, -c, printf %s $(hostname)]
