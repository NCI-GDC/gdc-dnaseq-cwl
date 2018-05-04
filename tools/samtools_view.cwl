#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/samtools:fb799a0f68670323e0b8fb0905807c3fa78e6d8d4caa074d600d2fe21ccf5a0f
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: INPUT
    format: "edam:format_2572"
    type: File
    inputBinding:
      position: 0

  - id: header_included
    type: boolean
    default: true
    inputBinding:
      prefix: -h

  - id: output_format
    type: string
    default: "BAM"
    inputBinding:
      prefix: --output-fmt

  - id: threads
    type: long
    default: 1
    inputBinding:
      prefix: --threads

outputs:
  - id: OUTPUT
    format: "edam:format_2572"
    type: File
    outputBinding:
      glob: |
        ${
          return inputs.INPUT.nameroot + "." + inputs.output_format.toLowerCase();
        }

arguments:
  - valueFrom: |
      ${
        return inputs.INPUT.nameroot + "." + inputs.output_format.toLowerCase();
      }
    prefix: -o

baseCommand: [/usr/local/bin/samtools, view]
