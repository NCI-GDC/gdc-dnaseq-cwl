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
    type: string
    outputBinding:
      glob: output
      loadContents: true
      outputEval: $(self[0].contents)

stdout: output

baseCommand: [bash, -c, "printf %s $(ip addr list eth0 | grep 'link/ether' | cut -d' ' -f6 | cut -d/ -f1)"]
