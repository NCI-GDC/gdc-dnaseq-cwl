cwlVersion: v1.0
class: CommandLineTool
id: picard_markduplicates
requirements:
  - class: DockerRequirement
    dockerPull: "{{ docker_repo }}/picard:{{ picard }}"
  - class: InlineJavascriptRequirement
    expressionLib:
      $import: ./expression_lib.cwl
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 15000
    ramMax: 15000
    tmpdirMin: $(Math.ceil(1.1 * sum_file_array_size(inputs.INPUT)))
    outdirMin: $(Math.ceil(1.1 * sum_file_array_size(inputs.INPUT)))

inputs:
  INPUT:
    type:
      type: array
      items: File
      inputBinding:
        prefix: INPUT=
        separate: false

  TMP_DIR:
    default: .
    type: string
    inputBinding:
      prefix: TMP_DIR=
      separate: false

  VALIDATION_STRINGENCY:
    default: STRICT
    type: string
    inputBinding:
      prefix: VALIDATION_STRINGENCY=
      separate: false

  ASSUME_SORT_ORDER:
    type: string
    inputBinding:
      prefix: ASSUME_SORT_ORDER=
      separate: false

  OUTBAM:
    type: string
    inputBinding:
      prefix: OUTPUT=
      separate: false

outputs:
  OUTPUT:
    type: File
    outputBinding:
      glob: $(inputs.OUTBAM)

  METRICS:
    type: File
    outputBinding:
      glob: $(inputs.OUTBAM + ".metrics")

arguments:
  - valueFrom: $(inputs.OUTBAM + ".metrics")
    prefix: METRICS_FILE=
    separate: false

  - valueFrom: 'ASSUME_SORT_ORDER=coordinate'
    position: 99

baseCommand: [java, -jar, /usr/local/bin/picard.jar, MarkDuplicates]