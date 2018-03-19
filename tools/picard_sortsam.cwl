 #!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/picard:6a031f4df1907fd13a58c9351855008b9dd8c5793560cb0d81ba4196d31dc88b
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 10000
    ramMax: 10000
    tmpdirMin: $(Math.ceil(1.2 * inputs.INPUT.sizee / 1048576))
    tmpdirMax: $(Math.ceil(1.2 * inputs.INPUT.sizee / 1048576))
    outdirMin: $(Math.ceil(1.2 * inputs.INPUT.sizee / 1048576))
    outdirMax: $(Math.ceil(1.2 * inputs.INPUT.sizee / 1048576))

class: CommandLineTool

inputs:
  - id: CREATE_INDEX
    type: string
    default: "true"
    inputBinding:
      prefix: CREATE_INDEX=
      separate: false

  - id: INPUT
    type: File
    format: "edam:format_2572"
    inputBinding:
      prefix: INPUT=
      separate: false

  - id: OUTPUT
    type: string
    inputBinding:
      prefix: OUTPUT=
      separate: false

  - id: SORT_ORDER
    type: string
    default: "coordinate"
    inputBinding:
      prefix: SORT_ORDER=
      separate: false

  - id: TMP_DIR
    type: string
    default: .
    inputBinding:
      prefix: TMP_DIR=
      separate: false

  - id: VALIDATION_STRINGENCY
    type: string
    default: "STRICT"
    inputBinding:
      prefix: VALIDATION_STRINGENCY=
      separate: false

outputs:
  - id: SORTED_OUTPUT
    type: File
    format: "edam:format_2572"
    outputBinding:
      glob: $(inputs.OUTPUT)
    secondaryFiles:
      - ^.bai
          
baseCommand: [java, -jar, /usr/local/bin/picard.jar, SortSam]
