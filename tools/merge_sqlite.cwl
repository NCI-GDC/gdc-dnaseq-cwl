#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/merge_sqlite:3ce7e2115ea28564bea3cff3ce58f7ea8ca0eac5ab2e9b3e1c5d992a56e1088e
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: source_sqlite
    format: "edam:format_3621"
    type:
      type: array
      items: File
      inputBinding:
        prefix: "--source_sqlite"

  - id: task_uuid
    type: string
    inputBinding:
      prefix: "--task_uuid"

outputs:
  - id: destination_sqlite
    format: "edam:format_3621"
    type: File
    outputBinding:
      glob: $(inputs.task_uuid + ".db")

  - id: log
    type: File
    outputBinding:
      glob: $(inputs.task_uuid + ".log")

baseCommand: [/usr/local/bin/merge_sqlite]
