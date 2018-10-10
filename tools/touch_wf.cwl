#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

inputs:
  - id: touchfile
    type: string

outputs:
  - id: workflowString
    type: string
    outputSource: touch/astring

steps:
  - id: touch
    run: touch.cwl
    in:
      - id: input
        source: touchfile
    out:
      - id: output
      - id: astring
