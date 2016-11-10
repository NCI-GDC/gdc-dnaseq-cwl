#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool
requirements:
  - class: DockerRequirement
    dockerPull: ubuntu:xenial-20161010

inputs:
  - id: load1
    type: File

  - id: load2
    type: File

  - id: load3
    type: File

outputs:
  - id: token
    type: File
    outputBinding:
      glob: "token"
    
baseCommand: [touch, token]
