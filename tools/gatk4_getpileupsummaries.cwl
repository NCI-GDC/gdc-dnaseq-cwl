#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gatk:latest
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: input
    format: "edam:format_2572"
    type: File
    inputBinding:
      prefix: --input
    secondaryFiles:
      - ^.bai

  - id: TMP_DIR
    type: string
    default: "."
    inputBinding:
      prefix: --TMP_DIR

outputs:
  - id: output
    type: File
    outputBinding:
      glob: $(inputs.input.nameroot + "_pileupsummaries.table")

arguments:
  - valueFrom: $(inputs.input.nameroot + "_pileupsummaries.table")
    prefix: --output
    separate: true

baseCommand: [java, -jar, /usr/local/bin/gatk-package-4.0.7.0-local.jar, GetPileupSummaries]
