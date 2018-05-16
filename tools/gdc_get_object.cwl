#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/curl:c0a4eaf9b928f14db71fa28fcc928b602e74dbfd168a3d761a134b0ba5ec6d94
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 2000
    ramMax: 2000
    tmpdirMin: $(Math.ceil (inputs.file_size / 1048576))
    tmpdirMax: $(Math.ceil (inputs.file_size / 1048576))
    outdirMin: $(Math.ceil (inputs.file_size / 1048576))
    outdirMax: $(Math.ceil (inputs.file_size / 1048576))

inputs:
  - id: gdc_token
    type: File
    inputBinding:
      loadContents: true
      valueFrom: $(null)

  - id: gdc_uuid
    type: string

  - id: file_size
    type: long
    default: 1

outputs:
  - id: output
    type: File
    outputBinding:
      glob: "*"

arguments:
  - valueFrom: "X-Auth-Token: $(inputs.gdc_token.contents)"
    position: 0

  - valueFrom: https://api.gdc.cancer.gov/data/$(inputs.gdc_uuid)
    position: 1

baseCommand: [curl, --remote-name, --remote-header-name, --header]
