#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/git-client:latest
  - class: ShellCommandRequirement

inputs:
  - id: repo
    type: string
    inputBinding:
      position: 0

  - id: branch
    type: string
    inputBinding:
      position: 1

outputs:
  - id: output
    type: string
    outputBinding:
      glob: output
      loadContents: true
      outputEval: $(self[0].contents)

stdout: output

arguments:
  - valueFrom: " | awk '{printf $1}'"
    position: 2
    shellQuote: false

baseCommand: [git, ls-remote]
