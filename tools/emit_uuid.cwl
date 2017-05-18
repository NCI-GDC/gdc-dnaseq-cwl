#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: python:3.6.1-slim

class: CommandLineTool

inputs:
  []

outputs:
  - id: output
    type: string
    outputBinding:
      glob: output
      loadContents: true
      outputEval: $(self[0].contents)

stdout: output

baseCommand: [python3, -c, "import uuid; import sys; sys.stdout.write(str(uuid.uuid4()));"]
