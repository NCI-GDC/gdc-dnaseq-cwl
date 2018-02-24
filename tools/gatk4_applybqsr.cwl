#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gatk:f688a34765c4745e7e92ad484eab16aea71f7d6b430086cbe3f3c146ceffd521
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

  - id: bqsr-recal-file
    type: File
    inputBinding:
      prefix: --bqsr-recal-file

  - id: TMP_DIR
    type: string
    default: "."
    inputBinding:
      prefix: --TMP_DIR

outputs:
  - id: output_bam
    type: File
    outputBinding:
      glob: $(inputs.input.basename)

arguments:
  - valueFrom: $(inputs.input.basename)
    prefix: --output

baseCommand: [java, -jar, /usr/local/bin/gatk-package-4.0.0.0-local.jar, ApplyBQSR]
