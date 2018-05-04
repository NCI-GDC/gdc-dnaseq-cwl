#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gatk:d1c1ac48c94b375d31c95c67b5e1fffcbb79682f743ed037f5690f1dfd01bf99
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

  - id: emit-original-quals
    type:
      - type: enum
        symbols: ["true", "false"]
    default: "true"
    inputBinding:
      prefix: --emit-original-quals

  - id: TMP_DIR
    type: string
    default: "."
    inputBinding:
      prefix: --TMP_DIR

outputs:
  - id: output_bam
    format: "edam:format_2572"
    type: File
    outputBinding:
      glob: $(inputs.input.basename)
    secondaryFiles:
      - ^.bai

arguments:
  - valueFrom: $(inputs.input.basename)
    prefix: --output

baseCommand: [java, -jar, /usr/local/bin/gatk-package-4.0.4.0-local.jar, ApplyBQSR]
