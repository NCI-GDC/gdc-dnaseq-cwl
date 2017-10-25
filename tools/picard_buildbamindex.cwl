#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/picard:b1d49dca1bcec6677ad6af8514ae3efed2395ecca2831befd3805cb3b2e01b3d
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
