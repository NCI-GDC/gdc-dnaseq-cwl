#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/bam_reheader:2a404a0eabc344da137e6573a7e6cdb0cacb646e386261bfbcdf0990422a5096
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: input
    type: File
    format: "edam:format_2572"
    inputBinding:
      prefix: --bam_path

outputs:
  - id: output
    type: File
    format: "edam:format_2572"
    outputBinding:
      glob: $(inputs.input.basename)

  - id: log
    type: File
    outputBinding:
      glob: $(inputs.input.basename + ".log")

baseCommand: [/usr/local/bin/bam_reheader]
