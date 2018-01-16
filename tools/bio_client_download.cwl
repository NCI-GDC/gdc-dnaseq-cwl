#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/bio-client:09adc5f3c26dcc575531a38ee32d9adb104cf040270f76bae93c36d1b69b5010
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 2000
    ramMax: 2000
    tmpdirMin: $(inputs.file_size)
    tmpdirMax: $(inputs.file_size)
    outdirMin: $(inputs.file_size)
    outdirMax: $(inputs.file_size)

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

outputs:
  - id: output
    type: File
    outputBinding:
      glob: "*"
    
baseCommand: [/usr/local/bin/bio_client.py]
