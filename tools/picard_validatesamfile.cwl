#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/picard:b1d49dca1bcec6677ad6af8514ae3efed2395ecca2831befd3805cb3b2e01b3d
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: INPUT
    type: File
    format: "edam:format_2572"
    inputBinding:
      prefix: INPUT=
      separate: false

  - id: MAX_OUTPUT
    type: int
    default: 2147483647
    inputBinding:
      prefix: MAX_OUTPUT=
      separate: false

  - id: MODE
    type: string
    default: VERBOSE
    inputBinding:
      prefix: MODE=
      separate: false

  - id: TMP_DIR
    type: string
    default: .
    inputBinding:
      prefix: TMP_DIR=
      separate: false

  - id: VALIDATION_STRINGENCY
    default: STRICT
    type: string
    inputBinding:
      prefix: VALIDATION_STRINGENCY=
      separate: false

outputs:
  - id: OUTPUT
    type: File
    outputBinding:
      glob: $(inputs.INPUT.basename + ".metrics")

arguments:
  - valueFrom: $(inputs.INPUT.basename + ".metrics")
    prefix: OUTPUT=
    separate: false
      
successCodes: [0, 1]

baseCommand: [java, -jar, /usr/local/bin/picard.jar, ValidateSamFile]
