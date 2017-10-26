#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/curl:c37090fe49ce21554b7d0550455a93b5a4a1548e4eea8c071414d8af5991c5fe

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

  - valueFrom: https://gdc-api.nci.nih.gov/data/$(inputs.gdc_uuid)
    position: 1

baseCommand: [curl, --remote-name, --remote-header-name, --header]
