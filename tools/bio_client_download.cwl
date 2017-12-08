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
      position: 0

  - id: dir_path
    type: string
    default: "."
    inputBinding:
      prefix: --dir_path

  - id: download
    type: string
    default: download
    inputBinding:
      position: 1

  - id: download_handle
    type: string
    inputBinding:
      position: 99

outputs:
  - id: output
    type: File
    outputBinding:
      glob: "*"
    
baseCommand: [/usr/local/bin/bio_client.py]
