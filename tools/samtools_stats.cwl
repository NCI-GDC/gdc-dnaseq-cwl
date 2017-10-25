#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/samtools:e6119c2f924d79f277ced8557730213e5862308a7c6fc319218dc9059580cc5e
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: INPUT
    type: File
    format: "edam:format_2572"
    inputBinding:
      position: 0

outputs:
  - id: OUTPUT
    type: File
    outputBinding:
      glob: $(inputs.INPUT.nameroot + ".stats")

stdout: $(inputs.INPUT.nameroot + ".stats")

baseCommand: [/usr/local/bin/samtools, stats]
