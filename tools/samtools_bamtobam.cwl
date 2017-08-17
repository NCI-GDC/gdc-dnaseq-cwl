#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/samtools:ad7a689f93eee2650c5115066354ebc742e05a3059244a439315b978ba88c5b2
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: INPUT
    format: "edam:format_2572"
    type: File
    inputBinding:
      position: 0

outputs:
  - id: OUTPUT
    format: "edam:format_2572"
    type: File
    outputBinding:
      glob: $(inputs.INPUT.basename)

stdout: $(inputs.INPUT.basename)

baseCommand: [/usr/local/bin/samtools, view, -Shb]
