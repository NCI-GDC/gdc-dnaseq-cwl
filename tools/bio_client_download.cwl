#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/bio-client:latest
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
      position: 99

  - id: download
    type: string
    default: download
    inputBinding:
      position: 1

  - id: download_handle
    type: string
    inputBinding:
      position: 98

  - id: file_size
    type: long
    default: 1

outputs:
  - id: output
    type: File
    outputBinding:
      glob: "*"
    
baseCommand: [/usr/local/bin/bio_client.py]
