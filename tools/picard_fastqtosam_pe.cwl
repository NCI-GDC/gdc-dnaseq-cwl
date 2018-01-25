#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/picard:6a031f4df1907fd13a58c9351855008b9dd8c5793560cb0d81ba4196d31dc88b
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 15000
    ramMax: 15000
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
  - id: PLATFORM
    type: ["null", enum]
    symbols: ["ILLUMINA", "SOLID", "LS454", "HELICOS", "PACBIO"]
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
      type: array
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
    type: ["null", enum]
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
    type: ["null", enum]
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
    type: ["null", enum]
    symbols: [ERROR, WARNING, INFO, DEBUG]
    inputBinding:
      prefix: VERBOSITY=
      separate: false

  - id: QUIET
    type: ["null", enum]
    symbols: ["true", "false"]
    inputBinding:
      prefix: QUIET=
      separate: false

  - id: VALIDATION_STRINGENCY
    type: ["null", enum]
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
    type: string
    default: "true"
    inputBinding:
      prefix: CREATE_INDEX=
      separate: false

  - id: CREATE_MD5_FILE
    type: ["null", enum]
    symbols: ["true", "false"]
    inputBinding:
      prefix: CREATE_MD5_FILE=
      separate: false

outputs:
  - id: OUTPUT
    type: File
    format: "edam:format_2572"
    outputBinding:
      glob: $(inputs.INPUT.READ_GROUP_NAME).bam

arguments:
  - valueFrom: $(inputs.INPUT.READ_GROUP_NAME).bam
    prefix: OUTPUT=
    separate: false

baseCommand: [java, -jar, /usr/local/bin/picard.jar, FastqToSam]
