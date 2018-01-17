#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/fastqc_db:b9c09ea65f40e154d239ebf494f4cd14ed2526cb6b70f65f9d822d3ebd4f1594
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 1000
    ramMax: 1000
    tmpdirMin: 100
    tmpdirMax: 100
    outdirMin: 10
    outdirMax: 10

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
