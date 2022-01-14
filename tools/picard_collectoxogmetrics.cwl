cwlVersion: v1.0
id: picard_collectoxogmetrics
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/picard:2.26.10
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 10000
    ramMax: 10000
    tmpdirMin: 5
    tmpdirMax: 5
    outdirMin: 5
    outdirMax: 5

class: CommandLineTool

inputs:
  DB_SNP:
    type: File
    inputBinding:
      prefix: DB_SNP=
      separate: false

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

  TMP_DIR:
    type: string
    default: .
    inputBinding:
      prefix: TMP_DIR=
      separate: false

  USE_OQ:
    type: string
    default: "true"
    inputBinding:
      prefix: USE_OQ=
      separate: false

  VALIDATION_STRINGENCY:
    default: STRICT
    type: string
    inputBinding:
      prefix: VALIDATION_STRINGENCY=
      separate: false

  CONTEXTS:
    type:
      type: array
      items: string
      inputBinding:
        prefix: CONTEXTS=
        separate: false

outputs:
  OUTPUT:
    type: File
    outputBinding:
      glob: $(inputs.INPUT.basename + ".oxometrics")

arguments:
  - valueFrom: $(inputs.INPUT.basename + ".oxometrics")
    prefix: OUTPUT=
    separate: false

baseCommand: [java, -jar, /usr/local/bin/picard.jar, CollectOxoGMetrics]
