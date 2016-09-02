#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/jeremiahsavage/capturekits
  - class: InlineJavascriptRequirement

class: ExpressionTool

inputs:
  - id: capturekey
    type: string

outputs:
  - id: bait
    type: File
    outputBinding:
      glob: "*bait*"

  - id: bait
    type: File
    outputBinding:
      glob: "*target*"

arguments:
  - valueFrom: |
      ${

      }

baseCommand: [python, -c]
