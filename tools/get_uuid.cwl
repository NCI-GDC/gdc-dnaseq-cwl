#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: python:3.6.0-slim
  - class: ShellCommandRequirement

class: CommandLineTool

inputs:
  - id: input
    type: File

outputs:
  - id: uuid
    type: File
    outputBinding:
      glob: uuid

stdout: uuid
      
arguments:
  - valueFrom: "python3 -c 'import uuid; print(uuid.uuid4());'"
    shellQuote: false
