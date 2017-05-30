#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/curl:584c4fa535adf9d52d9e1284339494f2c93eceb16434230f4388052aeb5bc5e1
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
  - valueFrom: "X-Auth-Token: $(inputs.gdc_token.contents)"
    position: 0

  - valueFrom: https://gdc-api.nci.nih.gov/data/$(inputs.gdc_uuid)
    position: 1

baseCommand: [curl, --remote-name, --remote-header-name, --header]
