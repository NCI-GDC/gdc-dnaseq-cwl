#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/bio-client:09adc5f3c26dcc575531a38ee32d9adb104cf040270f76bae93c36d1b69b5010

inputs:
  - id: config-file
    type: File
    inputBinding:
      prefix: --config-file
      position: 0

  - id: upload
    type: string
    default: upload
    inputBinding:
      position: 1

  - id: upload-bucket
    type: string
    inputBinding:
      prefix: --upload-bucket
      position: 2

  - id: upload-key
    type: string
    inputBinding:
      prefix: --upload_key
      position: 3

  - id: input
    type: File
    inputBinding:
      position: 99

outputs:
  - id: output
    type: File
    outputBinding:
      glob: "*_upload.json"      

baseCommand: [/usr/local/bin/bio_client.py]
