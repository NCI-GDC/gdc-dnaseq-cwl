#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
 - class: InlineJavascriptRequirement
 - class: StepInputExpressionRequirement

inputs:
  - id: repo_url
    type: string
  - id: git_hash
    type: string

outputs:
  - id: git_dir
    type: Directory
    outputSource: transform/output

steps:
  - id: extract
    run: ../../tools/git_clone_repo.cwl
    in:
      - id: repo_url
        source: repo_url
    out:
      - id: output
 
  - id: transform
    run: ../../tools/git_reset_repo.cwl
    in:
      - id: repo
        source: extract/output
      - id: git_hash
        source: git_hash
    out:
      - id: output
