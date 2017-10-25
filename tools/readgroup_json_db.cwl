#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/readgroup_json_db:eed25660a0e54d5f840b8cf56caebb0dbe8f09a727a6700b7d5f4d7906f385b3
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
