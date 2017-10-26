#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/git-client:cd11e0475ba67cba39c5590533208bc38e82f5904b51ee487943f2b04f6c9469
  - class: EnvVarRequirement
    envDef:
      - envName: "GIT_DIR"
        envValue: $(inputs.repo.basename)/.git
  - class: InitialWorkDirRequirement
    listing:
      - entryname: $(inputs.repo.basename)
        entry: $(inputs.repo)
        writable: true

inputs:
  - id: repo
    type: Directory

  - id: git_hash
    type: string
    inputBinding:
      position: 1

outputs:
  - id: output
    type: Directory
    outputBinding:
      glob: $(inputs.repo.basename)

baseCommand: [git, checkout]
