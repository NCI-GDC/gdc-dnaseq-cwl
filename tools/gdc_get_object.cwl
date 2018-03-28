#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/curl:d27480e7ac07e583146362d59f48254c2f59dfaa023212d12e091e136a52bcdf

inputs:
  - id: gdc_token
    type: File
    inputBinding:
      loadContents: true
      valueFrom: $(null)

  - id: gdc_uuid
    type: string

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
