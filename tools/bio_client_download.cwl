#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/bio-client:latest

inputs:
  - id: config-file
    type: File
    inputBinding:
      prefix: -c

  - id: download_handle
    type: string
    inputBinding:
      position: 99

  - id: file_path
    type: string
    default: "."
    inputBinding:
      prefix: --file_path

outputs:
  - id: output
    type: File
    outputBinding:
      glob: "*"
    
baseCommand: [/usr/local/bin/bio_client.py, download]
