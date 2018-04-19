#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/samtools:76b0e231097a648b3fb2ace48e264a1e6aca02847bb62ba30f225144eda14f71
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 2000
    ramMax: 2000
    tmpdirMin: $(Math.ceil(2.1 * inputs.INPUT.size / 1048576))
    tmpdirMax: $(Math.ceil(2.1 * inputs.INPUT.size / 1048576))
    outdirMin: $(Math.ceil(1.1 * inputs.INPUT.size / 1048576))
    outdirMax: $(Math.ceil(1.1 * inputs.INPUT.size / 1048576))

class: CommandLineTool

inputs:
  - id: INPUT
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
