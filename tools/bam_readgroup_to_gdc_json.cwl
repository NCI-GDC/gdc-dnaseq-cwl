#!/usr/bin/env cwl-runner
$namespaces:
  edam: "http://edamontology.org/"
cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/bam-readgroup-to-gdc-json:latest
  - class: InlineJavascriptRequirement
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
  - id: INPUT
    type: File
    inputBinding:
      prefix: --bam_path

outputs:
  - id: OUTPUT
    format: "edam:format_3464"
    type: File
    outputBinding:
      glob: "*.json"

  - id: log
    type: File
    outputBinding:
      glob: "output.log"

baseCommand: [/usr/local/bin/bam_readgroup_to_gdc_json]
