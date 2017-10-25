#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/picard:52ac4bf00f5d846a34c67e02f329f2e57a12824dae7021d28866b2656234ff61
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: IGNORE_WARNINGS
    type: string
    default: "true"
    inputBinding:
      prefix: IGNORE_WARNINGS=
      separate: false

  - id: INDEX_VALIDATION_STRINGENCY
    type: string
    default: "NONE"
    inputBinding:
      prefix: INDEX_VALIDATION_STRINGENCY=
      separate: false

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

  - id: VALIDATE_INDEX
    type: string
    default: "false"
    inputBinding:
      prefix: VALIDATE_INDEX=
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
      
successCodes: [0, 2, 3]

baseCommand: [java, -jar, /usr/local/bin/picard.jar, ValidateSamFile]
