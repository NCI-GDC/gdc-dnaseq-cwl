#!/usr/bin/env cwl-runner
#$namespaces:"
  #edam: "http://edamontology.org/"
cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/fastqc_db:3383ae9c9beaf905682b21cab14d20b3bc4fc738c7e1e126da99dc288ba016ac
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
    format: "edam:format_3621"
    outputBinding:
      glob: $(inputs.INPUT.nameroot + ".db")

          
baseCommand: [/usr/local/bin/fastqc_db]
