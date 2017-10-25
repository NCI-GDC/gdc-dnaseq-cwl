#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/readgroup_json_db:c027194c39b13ad2a31881aa49a706263cbde1177e1537907f0dcd9d449521ec
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: json_path
    type: File
    format: "edam:format_3464"
    inputBinding:
      prefix: --json_path

  - id: task_uuid
    type: string
    inputBinding:
      prefix: --task_uuid

outputs:
  - id: log
    type: File
    outputBinding:
      glob: $(inputs.task_uuid +".log")

  - id: output_sqlite
    type: File
    format: "edam:format_3621"
    outputBinding:
      glob: $(inputs.task_uuid + ".db")         
          
baseCommand: [/usr/local/bin/readgroup_json_db]
