 #!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/picard:985a0dd0c65e5a92b9d8bd13a2333ae0474d963645c416907a0573572709f6b8
  - class: InlineJavascriptRequirement

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
