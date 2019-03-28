#!/usr/bin/env cwl-runner
$namespaces:
  edam: "http://edamontology.org/"
cwlVersion: v1.0

requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/fastqc_to_json:0ebd446f08d9eb6ed5b069e9ae53ad822236dc56bb1154f9df0e0c22b5724ae7
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 1000
    ramMax: 1000
    tmpdirMin: 1
    tmpdirMax: 1
    outdirMin: 1
    outdirMax: 1

class: CommandLineTool

inputs:
  - id: sqlite_path
    type: File
    inputBinding:
      prefix: --sqlite_path

outputs:
  - id: OUTPUT
    type: File
    format: "edam:format_3464"
    outputBinding:
      glob: "fastqc.json"

baseCommand: [/usr/local/bin/fastqc_to_json]
