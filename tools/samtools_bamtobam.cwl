#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/samtools:6161be62579a6f4fa21e1c200a6bf42585ac602829999d582ecd35825ca3695a
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 500
    ramMax: 500
    tmpdirMin: $(inputs.INPUT.size * 2.1)
    tmpdirMax: $(inputs.INPUT.size * 2.1)
    outdirMin: $(inputs.INPUT.size * 1.1)
    outdirMax: $(inputs.INPUT.size * 1.1)

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
