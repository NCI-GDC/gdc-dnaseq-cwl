#!/usr/bin/env cwl-runner
#$namespaces:"
  #edam: "http://edamontology.org/"
cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/samtools:147bd4cc606a63c7435907d97fea6e94e9ea9ed58c18f390cab8bc40b1992df7
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
    format: "edam:format_2573"
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
