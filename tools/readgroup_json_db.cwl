#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/readgroup_json_db:0b69833722a66236e9519ce1d3955368a645c4bcf26d1f7416bbacbdc5deef9b
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
  - id: json_path
    type: File
    format: "edam:format_3464"
    inputBinding:
      prefix: --json_path

  - id: job_uuid
    type: string
    inputBinding:
      prefix: --job_uuid

outputs:
  - id: log
    type: File
    outputBinding:
      glob: $(inputs.job_uuid +".log")

  - id: output_sqlite
    type: File
    format: "edam:format_3621"
    outputBinding:
      glob: $(inputs.job_uuid + ".db")         
          
baseCommand: [/usr/local/bin/readgroup_json_db]
