#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/curl:1
  - class: EnvVarRequirement
    envDef:
      - envName: "token"
        envValue: $(inputs.gdc_token.contents)

inputs:
  - id: gdc_token
    type: File
    inputBinding:
      loadContents: true
      valueFrom: null

  - id: gdc_uuid
    type: string

outputs:
  - id: output
    type: File
    outputBinding:
      glob: "*"

arguments:
  - valueFrom: https://gdc-api.nci.nih.gov/data/$(inputs.gdc_uuid)
    position: 0

baseCommand: [curl, --remote-name, --remote-header-name, --header, "X-Auth-Token: ${token}"]
