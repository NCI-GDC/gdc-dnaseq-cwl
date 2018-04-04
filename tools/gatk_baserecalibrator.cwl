#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gatk:a955c0a05d12389585f8a4a154b1cb6fe4f8e88e6d4c193c4d9877b17b8b75e9
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

  - id: known-sites
    format: "edam:format_3016"
    type: File
    inputBinding:
      prefix: --known-sites
    secondaryFiles:
      - .tbi

  - id: reference
    format: "edam:format_1929"
    type: File
    inputBinding:
      prefix: --reference
    secondaryFiles:
      - .fai
      - ^.dict

  - id: TMP_DIR
    type: string
    default: "."
    inputBinding:
      prefix: --TMP_DIR

outputs:
  - id: output_grp
    type: File
    outputBinding:
      glob: $(inputs.input.nameroot + "_bqsr.grp")

  - id: output_log
    type: File
    outputBinding:
      glob: $(inputs.log_to_file)

arguments:
  - valueFrom: $(inputs.input.nameroot + "_bqsr.grp")
    prefix: --output
    separate: true

baseCommand: [java, -jar, /usr/local/bin/gatk-package-4.0.0.0-local.jar, -T, BaseRecalibrator]
