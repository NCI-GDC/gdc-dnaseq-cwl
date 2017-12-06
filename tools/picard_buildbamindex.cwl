#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/picard:43e6e7d6cc07dba36889023f23c3d34f4923ee0d76489d3ba0d5e3868d8b3e85
  - class: InitialWorkDirRequirement
    listing:
      - entryname: $(inputs.INPUT.basename)
        entry: $(inputs.INPUT)
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: INPUT
    type: File
    format: "edam:format_2572"
    inputBinding:
      prefix: INPUT=
      separate: false

  - id: VALIDATION_STRINGENCY
    type: string
    default: STRICT
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

arguments:
  - valueFrom: $(inputs.INPUT.nameroot + ".bai")
    prefix: OUTPUT=
    separate: false

baseCommand: [java, -jar, /usr/local/bin/picard.jar, BuildBamIndex]
