#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/picard:43e6e7d6cc07dba36889023f23c3d34f4923ee0d76489d3ba0d5e3868d8b3e85
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: INPUT
    type: File
    format: "edam:format_2572"
    inputBinding:
      prefix: INPUT=
      separate: false

  - id: REFERENCE_SEQUENCE
    type: File
    format: "edam:format_1929"
    inputBinding:
      prefix: REFERENCE_SEQUENCE=
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
      glob: $(inputs.INPUT.nameroot + ".metrics")

arguments:
  - valueFrom: $(inputs.INPUT.nameroot + ".metrics")
    prefix: OUTPUT=
    separate: false

baseCommand: [java, -jar, /usr/local/bin/picard.jar, CollectWgsMetrics]
