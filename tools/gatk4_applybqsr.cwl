#!/usr/bin/env cwl-runner
#$namespaces:"
  #edam: "http://edamontology.org/"
cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gatk:434cf2a0d55647d63127c60a23d6f4496b86214703220998fb10cb47bc5e0c57
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

  - id: tmp_dir
    type: string
    default: "."
    inputBinding:
      prefix: --tmp-dir

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

baseCommand: [java, -jar, /usr/local/bin/gatk-package-4.1.2.0-local.jar, ApplyBQSR]
