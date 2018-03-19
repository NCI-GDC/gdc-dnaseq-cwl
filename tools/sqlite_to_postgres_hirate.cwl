#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/sqlite_to_postgres:6ac493aa9b27dbb3fd4cbb4912e6e62a535f5692e510f0212fbddc53c2d1cc56
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
  - id: ini_section
    type: string
    inputBinding:
      prefix: --ini_section

  - id: postgres_creds_path
    type: File
    inputBinding:
      prefix: --postgres_creds_path

  - id: source_sqlite_path
    type: File
    inputBinding:
      prefix: --source_sqlite_path

  - id: job_uuid
    type: string
    inputBinding:
      prefix: --job_uuid

outputs:
  - id: log
    type: File
    outputBinding:
      glob: $(inputs.job_uuid + ".log")
          
baseCommand: [sqlite_to_postgres]
