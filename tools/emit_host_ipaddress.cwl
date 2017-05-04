#!/usr/bin/env cwl-runner

cwlVersion: v1.0

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

baseCommand: [bash, -c, "printf %s $(ip addr list eth0 | grep 'inet ' | cut -d' ' -f6 | cut -d/ -f1)"]
