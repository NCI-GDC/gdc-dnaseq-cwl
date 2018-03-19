#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/merge_sqlite:32bf383b197503e795278332d3c8bd5944f736f25ebaedb25a3a104252c3b76f
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
