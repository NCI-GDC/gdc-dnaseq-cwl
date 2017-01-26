#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: ShellCommandRequirement

inputs:
  []

outputs:
  - id: output
    type: File
    outputBinding:
      glob: output

stdout: output

arguments:
  - valueFrom: "ip addr list eth0 | grep 'inet ' | cut -d' ' -f6 | cut -d/ -f1"
    shellQuote: false
