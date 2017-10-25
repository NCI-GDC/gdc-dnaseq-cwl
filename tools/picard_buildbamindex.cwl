#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/picard:52ac4bf00f5d846a34c67e02f329f2e57a12824dae7021d28866b2656234ff61
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
