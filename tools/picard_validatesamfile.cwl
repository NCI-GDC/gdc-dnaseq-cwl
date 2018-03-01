#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/picard:6656e113191eeb56679abb378c2ef82362b2514fabd6eaec97a545c6343104a8
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 5000
    ramMax: 5000
    tmpdirMin: 1000
    tmpdirMax: 1000
    outdirMin: 1000
    outdirMax: 1000

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
    type: long
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
