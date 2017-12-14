#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/bio-client:0f5a85f883ad4a40bda37dfaf6868ffee31b290d3effbd74ce6fdc675129748b

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

  - id: input
    type: File
    inputBinding:
      position: 99

outputs:
  - id: output
    type: File
    outputBinding:
      glob: "upload.json"

arguments:
  - valueFrom: $(inputs.input.basename)
    prefix: --upload_key
    position: 3
      
      
baseCommand: [/usr/local/bin/bio_client.py]
