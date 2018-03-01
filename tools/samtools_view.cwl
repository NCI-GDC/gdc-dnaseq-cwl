#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/samtools:76b0e231097a648b3fb2ace48e264a1e6aca02847bb62ba30f225144eda14f71
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
