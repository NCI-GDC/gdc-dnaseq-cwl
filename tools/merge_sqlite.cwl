#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/merge_sqlite:08043fb3529685498a125773527fedb98e9c7ca3889189a7852b68383ab7e832
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
