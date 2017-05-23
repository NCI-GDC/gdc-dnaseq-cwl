#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/bam_reheader:5984ba6bec26e581d0ed758461eec37ea8395b1b6832e037c4ac0a3bcb8eb0e6
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
