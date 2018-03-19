#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/integrity_to_sqlite:40edb00dd1679ad7019ee4b8c634aadc1e8aa66e6baac8d0a72b7389dbac76bf
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: input_state
    type: string
    inputBinding:
      prefix: "--input_state"

  - id: ls_l_path
    type: File
    inputBinding:
      prefix: "--ls_l_path"

  - id: md5sum_path
    type: File
    inputBinding:
      prefix: "--md5sum_path"

  - id: sha256sum_path
    type: File
    inputBinding:
      prefix: "--sha256sum_path"

  - id: task_uuid
    type: string
    inputBinding:
      prefix: "--task_uuid"

outputs:
  - id: LOG
    type: File
    outputBinding:
      glob: $(inputs.task_uuid + ".log")

  - id: OUTPUT
    type: File
    outputBinding:
      glob: $(inputs.task_uuid + ".db")

baseCommand: [/usr/local/bin/integrity_to_sqlite]
