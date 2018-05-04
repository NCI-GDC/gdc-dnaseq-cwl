#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/picard:c967a1329fc014aa5c6a92b506b11ab4ac495854e9f2dfe51badf490191a612e
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 10000
    ramMax: 10000
    tmpdirMin: $(Math.ceil(inputs.INPUT.size / 1048576))
    tmpdirMax: $(Math.ceil(inputs.INPUT.size / 1048576))
    outdirMin: $(Math.ceil(inputs.INPUT.size / 1048576))
    outdirMax: $(Math.ceil(inputs.INPUT.size / 1048576))

class: CommandLineTool

inputs:
  - id: INPUT
    type: File
    format: "edam:format_2572"
    inputBinding:
      prefix: INPUT=
      separate: false

  - id: OUTPUT
    type: string
    inputBinding:
      prefix: OUTPUT=
      separate: false

  - id: OUTPUT_BY_READGROUP
    type:
      - "null"
      - type: enum
        symbols: ["true", "false"]
    inputBinding:
      prefix: OUTPUT_BY_READGROUP=
      separate: false

  - id: OUTPUT_BY_READGROUP_FILE_FORMAT
    type:
      - "null"
      - type: enum
        symbols: [sam, bam, cram, dynamic]
    inputBinding:
      prefix: OUTPUT_BY_READGROUP_FILE_FORMAT=
      separate: false

  - id: SORT_ORDER
    type:
      - "null"
      - type: enum
        symbols: [unsorted, queryname, coordinate, duplicate, unknown]
    inputBinding:
      prefix: SORT_ORDER=
      separate: false

  - id: RESTORE_ORIGINAL_QUALITIES
    type:
      - "null"
      - type: enum
        symbols: ["true", "false"]
    inputBinding:
      prefix: RESTORE_ORIGINAL_QUALITIES=
      separate: false

  - id: REMOVE_DUPLICATE_INFORMATION
    type:
      - "null"
      - type: enum
        symbols: ["true", "false"]
    inputBinding:
      prefix: REMOVE_DUPLICATE_INFORMATION=
      separate: false

  - id: REMOVE_ALIGNMENT_INFORMATION
    type:
      - "null"
      - type: enum
        symbols: ["true", "false"]
    inputBinding:
      prefix: REMOVE_ALIGNMENT_INFORMATION=
      separate: false

  # - id: ATTRIBUTE_TO_CLEAR
  #   type:
  #     - "null"
  #     - type: enum
  #       symbols: [NM, UQ, PG, MD, MQ, SA, MC, AS]
  #   inputBinding:
  #     prefix: ATTRIBUTE_TO_CLEAR=
  #     separate: false

  - id: SANITIZE
    type:
      - "null"
      - type: enum
        symbols: ["true", "false"]
    inputBinding:
      prefix: SANITIZE=
      separate: false

  - id: MAX_DISCARD_FRACTION
    type: ["null", double]
    inputBinding:
      prefix: MAX_DISCARD_FRACTION=
      separate: false

  - id: SAMPLE_ALIAS
    type: ["null", string]
    inputBinding:
      prefix: SAMPLE_ALIAS=
      separate: false

  - id: LIBRARY_NAME
    type: ["null", string]
    inputBinding:
      prefix: LIBRARY_NAME=
      separate: false

  - id: TMP_DIR
    default: .
    type: string
    inputBinding:
      prefix: TMP_DIR=
      separate: false

  - id: VERBOSITY
    type:
      - "null"
      - type: enum
        symbols: [ERROR, WARNING, INFO, DEBUG]
    inputBinding:
      prefix: VERBOSITY=
      separate: false

  - id: QUIET
    type:
      - "null"
      - type: enum
        symbols: ["true", "false"]
    inputBinding:
      prefix: QUIET=
      separate: false

  - id: VALIDATION_STRINGENCY
    type:
      - "null"
      - type: enum
        symbols: [STRICT, LENIENT, SILENT]
    inputBinding:
      prefix: VALIDATION_STRINGENCY=
      separate: false

  - id: COMPRESSION_LEVEL=
    type: ["null", long]
    inputBinding:
      prefix: COMPRESSION_LEVEL=
      separate: false

  - id: MAX_RECORDS_IN_RAM
    type: ["null", long]
    inputBinding:
      prefix: MAX_RECORDS_IN_RAM=
      separate: false

  - id: CREATE_INDEX
    type:
      - "null"
      - type: enum
        symbols: ["true", "false"]
    inputBinding:
      prefix: CREATE_INDEX=
      separate: false

  - id: CREATE_MD5_FILE
    type:
      - "null"
      - type: enum
        symbols: ["true", "false"]
    inputBinding:
      prefix: CREATE_MD5_FILE=
      separate: false

outputs:
  - id: OUTPUT_BAM
    type: File
    format: "edam:format_2572"
    outputBinding:
      glob: $(inputs.OUTPUT)

baseCommand: [java, -jar, /usr/local/bin/picard.jar, RevertSam]
