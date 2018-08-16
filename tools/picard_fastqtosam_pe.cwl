#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/picard:092d034713aff237cf07ef28c22a46a113d1a59dc7ec6d71beb72295044a46f8
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 10000
    ramMax: 10000
    tmpdirMin: $(Math.ceil(1.1 * (inputs.FASTQ.size + inputs.FASTQ2.size) / 1048576))
    tmpdirMax: $(Math.ceil(1.1 * (inputs.FASTQ.size + inputs.FASTQ2.size) / 1048576))
    outdirMin: $(Math.ceil(1.1 * (inputs.FASTQ.size + inputs.FASTQ2.size) / 1048576))
    outdirMax: $(Math.ceil(1.1 * (inputs.FASTQ.size + inputs.FASTQ2.size) / 1048576))

class: CommandLineTool

inputs:
  - id: FASTQ
    type: File
    format: "edam:format_2182"
    inputBinding:
      prefix: FASTQ=
      separate: false

  - id: FASTQ2
    type: File
    format: "edam:format_2182"
    inputBinding:
      prefix: FASTQ2=
      separate: false

  - id: READ_GROUP_NAME
    type: string
    inputBinding:
      prefix: READ_GROUP_NAME=
      separate: false

  - id: SAMPLE_NAME
    type: string
    inputBinding:
      prefix: SAMPLE_NAME=
      separate: false

  - id: LIBRARY_NAME
    type: ["null", string]
    inputBinding:
      prefix: LIBRARY_NAME=
      separate: false

  - id: PLATFORM_UNIT
    type: ["null", string]
    inputBinding:
      prefix: PLATFORM_UNIT=
      separate: false

  # https://gatkforums.broadinstitute.org/gatk/discussion/6472/read-groups
  # ["ILLUMINA", "SOLID", "LS454", "HELICOS", "PACBIO"]
  - id: PLATFORM
    type: ["null", string]
    inputBinding:
      prefix: PLATFORM=
      separate: false

  - id: SEQUENCING_CENTER
    type: ["null", string]
    inputBinding:
      prefix: SEQUENCING_CENTER=
      separate: false

  - id: PREDICTED_INSERT_SIZE
    type: ["null", long]
    inputBinding:
      prefix: PREDICTED_INSERT_SIZE=
      separate: false

  - id: PROGRAM_GROUP
    type: ["null", string]
    inputBinding:
      prefix: PROGRAM_GROUP=
      separate: false

  - id: PLATFORM_MODEL
    type: ["null", string]
    inputBinding:
      prefix: PLATFORM_MODEL=
      separate: false

  - id: COMMENT
    type:
      - "null"
      - type: array
        items: string
        inputBinding:
          prefix: COMMENT=
          separate: false

  - id: DESCRIPTION
    type: ["null", string]
    inputBinding:
      prefix: DESCRIPTION=
      separate: false

  - id: RUN_DATE
    type: ["null", string]
    inputBinding:
      prefix: RUN_DATE=
      separate: false

  - id: SORT_ORDER
    type:
      - "null"
      - type: enum
        symbols: [unsorted, queryname, coordinate, duplicate, unknown]
    inputBinding:
      prefix: SORT_ORDER=
      separate: false

  - id: MIN_Q
    type: ["null", long]
    inputBinding:
      prefix: MIN_Q=
      separate: false

  - id: MAX_Q
    type: ["null", long]
    inputBinding:
      prefix: MAX_Q=
      separate: false

  - id: ALLOW_AND_IGNORE_EMPTY_LINES
    type:
      - "null"
      - type: enum
        symbols: ["true", "false"]
    inputBinding:
      prefix: ALLOW_AND_IGNORE_EMPTY_LINES=
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
  - id: OUTPUT
    type: File
    format: "edam:format_2572"
    outputBinding:
      glob: $(inputs.READ_GROUP_NAME).bam

arguments:
  - valueFrom: $(inputs.READ_GROUP_NAME).bam
    prefix: OUTPUT=
    separate: false

baseCommand: [java, -jar, /usr/local/bin/picard.jar, FastqToSam]
