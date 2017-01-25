#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

inputs:
  - id: load1
    type:
      type: array
      items: File

  - id: load2
    type:
      type: array
      items: File

outputs:
  - id: token
    type: File
    outputBinding:
      glob: "token"
    
baseCommand: [touch, token]
