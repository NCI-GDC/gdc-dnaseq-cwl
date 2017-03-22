#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/sqlite:1
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: sqlite_expression
    type: string
    inputBinding:
      position: 1

  - id: sqlite_file
    type: File
    inputBinding:
      position: 0

stdout: output.txt

outputs:
  - id: result
    type: int
    outputBinding:
      glob: output.txt
      loadContents: true
      outputEval: "$(parseInt(self[0].contents))"

baseCommand: [sqlite3]
