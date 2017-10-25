#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/fastqc_db:e3b97c0f853a059517459b25fd58e2e594532a94e9208ce14a892ae1cc952056
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: INPUT
    type: File
    inputBinding:
      prefix: --INPUT

  - id: task_uuid
    type: string
    inputBinding:
      prefix: --task_uuid

outputs:
  - id: LOG
    type: File
    outputBinding:
      glob: $(inputs.task_uuid + ".log")

  - id: OUTPUT
    type: File
    outputBinding:
      glob: $(inputs.INPUT.nameroot + ".db")

          
baseCommand: [/usr/local/bin/fastqc_db]
