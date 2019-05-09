#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gatk:434cf2a0d55647d63127c60a23d6f4496b86214703220998fb10cb47bc5e0c57
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
      prefix: --tmp-dir

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

baseCommand: [java, -jar, /usr/local/bin/gatk-package-4.1.2.0-local.jar, CalculateContamination]
