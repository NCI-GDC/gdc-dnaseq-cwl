#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/sqlite_to_postgres:c032605a7a4d8892697f02d8611e64840414426dab3ca8a71f52434c616b04b6
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
