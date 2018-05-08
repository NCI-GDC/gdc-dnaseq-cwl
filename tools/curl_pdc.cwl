#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/curl:c0a4eaf9b928f14db71fa28fcc928b602e74dbfd168a3d761a134b0ba5ec6d94
  - class: EnvVarRequirement
    envDef:
      - envName: ftp_proxy
        envValue: $(inputs.env_ftp_proxy)
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: env_ftp_proxy
    type: string
    default: http://cloud-proxy:3128

  - id: output
    type: string
    inputBinding:
      prefix: --output

  - id: url
    type: string
    inputBinding:
      prefix: --url

outputs:
  - id: output_file
    type: File
    outputBinding:
      glob: $(inputs.output)
      
baseCommand: [curl]
