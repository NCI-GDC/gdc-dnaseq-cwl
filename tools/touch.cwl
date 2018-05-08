#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: ubuntu:bionic-20180426
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 250
    ramMax: 250
    tmpdirMin: 1
    tmpdirMax: 1
    outdirMin: 1
    outdirMax: 1

class: CommandLineTool

inputs:
  - id: input
    type: string
    inputBinding:
      position: 0

outputs:
  - id: output
    type: File
    outputBinding:
      glob: $(inputs.input)
      
baseCommand: [touch]
