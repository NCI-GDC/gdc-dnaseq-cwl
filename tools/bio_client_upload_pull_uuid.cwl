cwlVersion: v1.0
class: CommandLineTool
id: bio_client_upload_pull_uuid
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/bio-client:latest
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 1000
    ramMax: 1000
    tmpdirMin: 1
    tmpdirMax: 1
    outdirMin: 1
    outdirMax: 1

inputs:
  config-file:
    type: File
    inputBinding:
      prefix: --config-file
      position: 0

  upload:
    type: string
    default: upload
    inputBinding:
      position: 1

  upload-bucket:
    type: string
    inputBinding:
      prefix: --upload-bucket
      position: 2

  upload-key:
    type: string
    inputBinding:
      prefix: --upload_key
      position: 3

  input:
    type: File
    inputBinding:
      position: 99

outputs:
  output:
    type: File
    outputBinding:
      glob: "*_upload.json"      

baseCommand: [/usr/local/bin/bio_client.py]
