#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gatk:3e800f0a95f9c95ba8bad4ad00d823af3917337889181733da96fd9797b81732
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
