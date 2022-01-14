cwlVersion: v1.0
class: CommandLineTool
id: picard_collectwgsmetrics
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/picard:2.26.10
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

inputs:
  INPUT:
    type: File
    inputBinding:
      prefix: INPUT=
      separate: false

  REFERENCE_SEQUENCE:
    type: File
    inputBinding:
      prefix: REFERENCE_SEQUENCE=
      separate: false

  VALIDATION_STRINGENCY:
    default: STRICT
    type: string
    inputBinding:
      prefix: VALIDATION_STRINGENCY=
      separate: false

  USE_FAST_ALGORITHM:
    type: string
    default: "true"
    inputBinding:
      prefix: USE_FAST_ALGORITHM=
      separate: false

outputs:
  OUTPUT:
    type: File
    outputBinding:
      glob: $(inputs.INPUT.nameroot + ".metrics")

arguments:
  - valueFrom: $(inputs.INPUT.nameroot + ".metrics")
    prefix: OUTPUT=
    separate: false

baseCommand: [java, -jar, /usr/local/bin/picard.jar, CollectWgsMetrics]
