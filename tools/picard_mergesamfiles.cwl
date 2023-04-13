cwlVersion: v1.0
class: CommandLineTool
id: picard_mergesamfiles
requirements:
  - class: DockerRequirement
    dockerPull: "{{ docker_repo }}/picard:{{ picard }}"
  - class: InlineJavascriptRequirement
    expressionLib:
      $import: ./expression_lib.cwl
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 10000
    ramMax: 10000
    tmpdirMin: $(Math.ceil(2 * sum_file_array_size(inputs.INPUT)))
    outdirMin: $(Math.ceil(2 * sum_file_array_size(inputs.INPUT)))

inputs:
  ASSUME_SORTED:
    type: string
    default: "false"
    inputBinding:
      prefix: ASSUME_SORTED=
      separate: false

  CREATE_INDEX:
    type: string
    default: "true"
    inputBinding:
      prefix: CREATE_INDEX=
      separate: false

  INPUT:
    type:
      type: array
      items: File
      inputBinding:
        prefix: INPUT=
        separate: false

  INTERVALS:
    type: File?
    inputBinding:
      prefix: INTERVALS=
      separate: false

  MERGE_SEQUENCE_DICTIONARIES:
    type: string
    default: "false"
    inputBinding:
      prefix: MERGE_SEQUENCE_DICTIONARIES=
      separate: false

  OUTPUT:
    type: string
    inputBinding:
      prefix: OUTPUT=
      separate: false

  SORT_ORDER:
    type: string
    default: coordinate
    inputBinding:
      prefix: SORT_ORDER=
      separate: false

  TMP_DIR:
    type: string
    default: .
    inputBinding:
      prefix: TMP_DIR=
      separate: false

  USE_THREADING:
    type: string
    default: "true"
    inputBinding:
      prefix: USE_THREADING=
      separate: false

  VALIDATION_STRINGENCY:
    type: string
    default: STRICT
    inputBinding:
      prefix: VALIDATION_STRINGENCY=
      separate: false

outputs:
  MERGED_OUTPUT:
    type: File
    outputBinding:
      glob: $(inputs.OUTPUT)
    secondaryFiles:
      - "^.bai"

baseCommand: [java, -jar, /usr/local/bin/picard.jar, MergeSamFiles]
