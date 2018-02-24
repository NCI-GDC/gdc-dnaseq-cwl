#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/bio-client:95b0fff4bc26d48420093b4fff22bf2d2d83d8f152af429b316802b930fabcda
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

outputs:
  - id: output
    type: File
    outputBinding:
      glob: "*"
    
baseCommand: [/usr/local/bin/bio_client.py]
