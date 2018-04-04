#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/picard:3a00f3f0af49c3e5af1447bbc06b40afd16337f6519f9b811b80862926fe1233
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 10000
    ramMax: 10000
    tmpdirMin: 10
    tmpdirMax: 10
    outdirMin: 10
    outdirMax: 10

class: CommandLineTool

inputs:
  - id: INPUT
    type: File
    format: "edam:format_2572"
    inputBinding:
      prefix: INPUT=
      separate: false

  - id: REFERENCE_SEQUENCE
    type: File
    format: "edam:format_1929"
    inputBinding:
      prefix: REFERENCE_SEQUENCE=
      separate: false

  - id: VALIDATION_STRINGENCY
    default: STRICT
    type: string
    inputBinding:
      prefix: VALIDATION_STRINGENCY=
      separate: false

outputs:
  - id: OUTPUT
    type: File
    outputBinding:
      glob: $(inputs.INPUT.nameroot + ".metrics")

arguments:
  - valueFrom: $(inputs.INPUT.nameroot + ".metrics")
    prefix: OUTPUT=
    separate: false

baseCommand: [java, -jar, /usr/local/bin/picard.jar, CollectWgsMetrics]
