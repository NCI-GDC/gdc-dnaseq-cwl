cwlVersion: v1.0
class: CommandLineTool
id: picard_collecttargetedpcrmetrics
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/picard:2.26.9
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 32768
    ramMax: 32768
    tmpdirMin: 1000
    tmpdirMax: 1000
    outdirMin: 1000
    outdirMax: 1000

inputs:
  AMPLICON_INTERVALS:
    type: File
    inputBinding:
      prefix: AMPLICON_INTERVALS=
      position: 10
      separate: false

  CUSTOM_AMPLICON_SET_NAME:
    type: string?
    inputBinding:
      prefix: CUSTOM_AMPLICON_SET_NAME=
      position: 11
      separate: false

  CLIP_OVERLAPPING_READS:
    type: string
    default: "true"
    inputBinding:
      prefix: CLIP_OVERLAPPING_READS=
      position: 12
      separate: false

  COVERAGE_CAP:
    type: long
    default: 200
    inputBinding:
      prefix: COVERAGE_CAP=
      position: 13
      separate: false

  INPUT:
    type: File
    format: "edam:format_2572"
    inputBinding:
      prefix: INPUT=
      position: 14
      separate: false

  METRIC_ACCUMULATION_LEVEL:
    type:
      type: array
      items: string
      inputBinding:
        prefix: METRIC_ACCUMULATION_LEVEL=
        position: 15
        separate: false
    default:
      - "ALL_READS"
      - "LIBRARY"
      - "SAMPLE"
      - "READ_GROUP"

  MINIMUM_BASE_QUALITY:
    type: long
    default: 20
    inputBinding:
      prefix: MINIMUM_BASE_QUALITY=
      position: 16
      separate: false

  MINIMUM_MAPPING_QUALITY:
    type: long
    default: 20
    inputBinding:
      prefix: MINIMUM_MAPPING_QUALITY=
      position: 17
      separate: false

  NEAR_DISTANCE:
    type: long
    default: 250
    inputBinding:
      prefix: NEAR_DISTANCE=
      position: 18
      separate: false

  OUTPUT:
    type: string
    inputBinding:
      prefix: OUTPUT=
      position: 19
      separate: false

  PER_BASE_COVERAGE:
    type: string?
    inputBinding:
      prefix: PER_BASE_COVERAGE=
      position: 20
      separate: false

  PER_TARGET_COVERAGE:
    type: string?
    inputBinding:
      prefix: PER_TARGET_COVERAGE=
      position: 21
      separate: false

  REFERENCE_SEQUENCE:
    type: File
    format: "edam:format_1929"
    inputBinding:
      prefix: REFERENCE_SEQUENCE=
      position: 22
      separate: false
    secondaryFiles:
      - .fai

  SAMPLE_SIZE:
    type: long
    default: 10000
    inputBinding:
      prefix: SAMPLE_SIZE=
      position: 23
      separate: false

  TARGET_INTERVALS:
    type: File
    inputBinding:
      prefix: TARGET_INTERVALS=
      position: 24
      separate: false

  VALIDATION_STRINGENCY:
    default: STRICT
    type: string
    inputBinding:
      prefix: VALIDATION_STRINGENCY=
      position: 25
      separate: false

  java_xmx:
    default: 32G
    type: string
    inputBinding:
      position: -10
      prefix: -Xmx
      separate: false

outputs:
  METRIC_OUTPUT:
    type: File
    outputBinding:
      glob: $(inputs.OUTPUT)

arguments:
  - valueFrom: "-jar"
    position: -9

  - valueFrom: "/usr/local/bin/picard.jar"
    position: -8

  - valueFrom: "CollectTargetedPcrMetrics"
    position: -7

baseCommand: [java]
