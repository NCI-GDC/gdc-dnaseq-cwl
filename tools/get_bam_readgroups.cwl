#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/samtools:76b0e231097a648b3fb2ace48e264a1e6aca02847bb62ba30f225144eda14f71
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
