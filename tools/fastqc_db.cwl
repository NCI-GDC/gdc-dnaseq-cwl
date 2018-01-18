#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/fastqc_db:04e29e72e0fcf2f19538ed323b4f99049f7ace55b60f18ec000696dcf93a2f3d
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

  - id: job_uuid
    type: string
    inputBinding:
      prefix: --job_uuid

outputs:
  - id: LOG
    type: File
    outputBinding:
      glob: $(inputs.job_uuid + ".log")

  - id: OUTPUT
    type: File
    outputBinding:
      glob: $(inputs.INPUT.nameroot + ".db")

          
baseCommand: [/usr/local/bin/fastqc_db]
