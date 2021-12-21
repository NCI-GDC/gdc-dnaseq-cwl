cwlVersion: v1.0
class: CommandLineTool
id: picard_validatesamfile
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/picard:2.26.9
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

inputs:
  IGNORE_WARNINGS:
    type: string
    default: "true"
    inputBinding:
      prefix: IGNORE_WARNINGS=
      separate: false

  INDEX_VALIDATION_STRINGENCY:
    type: string
    default: "NONE"
    inputBinding:
      prefix: INDEX_VALIDATION_STRINGENCY=
      separate: false

  INPUT:
    type: File
    format: "edam:format_2572"
    inputBinding:
      prefix: INPUT=
      separate: false

  MAX_OUTPUT:
    type: long
    default: 100
    inputBinding:
      prefix: MAX_OUTPUT=
      separate: false

  MODE:
    type: string
    default: VERBOSE
    inputBinding:
      prefix: MODE=
      separate: false

  TMP_DIR:
    type: string
    default: .
    inputBinding:
      prefix: TMP_DIR=
      separate: false

  VALIDATE_INDEX:
    type: string
    default: "false"
    inputBinding:
      prefix: VALIDATE_INDEX=
      separate: false

  VALIDATION_STRINGENCY:
    default: STRICT
    type: string
    inputBinding:
      prefix: VALIDATION_STRINGENCY=
      separate: false

outputs:
  OUTPUT:
    type: File
    outputBinding:
      glob: $(inputs.INPUT.basename + ".metrics")

arguments:
  - valueFrom: $(inputs.INPUT.basename + ".metrics")
    prefix: OUTPUT=
    separate: false

successCodes: [0, 2, 3]

baseCommand: [java, -jar, /usr/local/bin/picard.jar, ValidateSamFile, IS_BISULFITE_SEQUENCED=false]
