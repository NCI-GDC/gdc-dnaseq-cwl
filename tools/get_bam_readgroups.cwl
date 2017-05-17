#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/samtools:c45b81b20cedb8632161232249e9c20e6313e4df82e3cf2bc44069b3d66b8f9f
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
