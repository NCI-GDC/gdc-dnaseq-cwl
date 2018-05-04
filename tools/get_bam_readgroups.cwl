#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/samtools:fb799a0f68670323e0b8fb0905807c3fa78e6d8d4caa074d600d2fe21ccf5a0f
  - class: InlineJavascriptRequirement
  - class: ShellCommandRequirement

class: CommandLineTool

inputs:
  - id: bam
    format: "edam:format_2572"
    type: File
    inputBinding:
      position: 0

outputs:
  - id: readgroups
    type: File
    outputBinding:
      glob: $(inputs.bam.basename + ".readgroups")

stdout: $(inputs.bam.basename + ".readgroups")

arguments:
  - valueFrom: $(["/usr/local/bin/samtools", "view", "-H", inputs.bam.path, "|", "grep", '^@RG'].join(' '))
    shellQuote: true

baseCommand: [bash, -c]
