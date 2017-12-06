#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/picard:43e6e7d6cc07dba36889023f23c3d34f4923ee0d76489d3ba0d5e3868d8b3e85
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: CREATE_INDEX
    type: string
    default: "true"
    inputBinding:
      prefix: CREATE_INDEX=
      separate: false

  - id: INPUT
    type: File
    format: "edam:format_2572"
    inputBinding:
      prefix: INPUT=
      separate: false

  - id: TMP_DIR
    default: .
    type: string
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
    format: "edam:format_2572"
    outputBinding:
      glob: $(inputs.INPUT.basename)
    secondaryFiles:
      - ^.bai

  - id: METRICS
    type: File
    outputBinding:
      glob: $(inputs.INPUT.basename + ".metrics")

arguments:
  - valueFrom: $(inputs.INPUT.basename)
    prefix: OUTPUT=
    separate: false

  - valueFrom: $(inputs.INPUT.basename + ".metrics")
    prefix: METRICS_FILE=
    separate: false

baseCommand: [java, -jar, /usr/local/bin/picard.jar, MarkDuplicates]
