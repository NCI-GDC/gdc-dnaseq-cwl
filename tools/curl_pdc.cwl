#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/curl:d27480e7ac07e583146362d59f48254c2f59dfaa023212d12e091e136a52bcdf
  - class: EnvVarRequirement
    envDef:
      - envName: ftp_proxy
        envValue: $(inputs.env_ftp_proxy)

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
