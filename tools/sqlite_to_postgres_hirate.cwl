#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/sqlite_to_postgres:407f904dd4303ffa496089dc68c456af391724fc697a32372b00f8a6aaa6c82f
  - class: InlineJavascriptRequirement

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

  - id: task_uuid
    type: string
    inputBinding:
      prefix: --task_uuid

outputs:
  - id: log
    type: File
    outputBinding:
      glob: $(inputs.task_uuid + ".log")
          
baseCommand: [sqlite_to_postgres]
