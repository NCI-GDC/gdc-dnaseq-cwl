#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/samtools:fb799a0f68670323e0b8fb0905807c3fa78e6d8d4caa074d600d2fe21ccf5a0f
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 5000
    ramMax: 5000
    tmpdirMin: 5
    tmpdirMax: 5
    outdirMin: 5
    outdirMax: 5

class: CommandLineTool

inputs:
  - id: INPUT
    type: File
    format: "edam:format_2572"
    inputBinding:
      position: 0
    secondaryFiles:
      - ^.bai

outputs:
  - id: OUTPUT
    type: File
    outputBinding:
      glob: $(inputs.INPUT.nameroot + ".idxstats")

stdout: $(inputs.INPUT.nameroot + ".idxstats")

baseCommand: [/usr/local/bin/samtools, idxstats]
