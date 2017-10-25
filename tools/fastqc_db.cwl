#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/fastqc_db:cb0cd4c16cb54b3e47d8909f3eb71e02f98f94f9e8c19350e8edd989a0d7d48e
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
