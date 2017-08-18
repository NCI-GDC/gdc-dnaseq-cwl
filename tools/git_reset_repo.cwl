#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/git-client:239651f2f67d001a2faf7e1f9e1836f5b618c21af388ecafefd21afa17f61778
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
