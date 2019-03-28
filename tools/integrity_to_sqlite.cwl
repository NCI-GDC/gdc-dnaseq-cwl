#!/usr/bin/env cwl-runner
$namespaces:
  edam: "http://edamontology.org/"
cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/integrity_to_sqlite:9b900fd5dedfdcb4b4c9a2034070463aa87b5e28a6e7ec59a0c504aab83c16f3
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 1000
    ramMax: 1000
    tmpdirMin: 5
    tmpdirMax: 5
    outdirMin: 5
    outdirMax: 5

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

  - id: job_uuid
    type: string
    inputBinding:
      prefix: "--job_uuid"

outputs:
  - id: LOG
    type: File
    outputBinding:
      glob: $(inputs.job_uuid + ".log")

  - id: OUTPUT
    format: "edam:format_3621"
    type: File
    outputBinding:
      glob: $(inputs.job_uuid + ".db")

baseCommand: [/usr/local/bin/integrity_to_sqlite]
