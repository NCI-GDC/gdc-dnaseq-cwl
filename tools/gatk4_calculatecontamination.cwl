#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gatk:a4a89bba62c91fec4b79b38a55d8a9353f503df0a55dd3950c7b3da640b1c6cf
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: input
    type: File
    inputBinding:
      prefix: --input

  - id: tmp_dir
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
