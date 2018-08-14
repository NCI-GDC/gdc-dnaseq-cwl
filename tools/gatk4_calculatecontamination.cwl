#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gatk:latest
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: input
    type: File
    inputBinding:
      prefix: --input

  - id: TMP_DIR
    type: string
    default: "."
    inputBinding:
      prefix: --TMP_DIR

  - id: bam_nameroot
    type: string

outputs:
  - id: output
    type: File
    outputBinding:
      glob: $(inputs.bam_nameroot + "_contamination.table")

arguments:
  - valueFrom: $(inputs.bam_nameroot + "_contamination.table")
    prefix: --output
    separate: true

baseCommand: [java, -jar, /usr/local/bin/gatk-package-4.0.7.0-local.jar, CalculateContamination]
