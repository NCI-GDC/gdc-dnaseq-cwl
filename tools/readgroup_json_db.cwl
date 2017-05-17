#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/readgroup_json_db:1a99a4ce11d29acd0e199081e56429ddc3c9680d88376ebdd5e9a33d3a936831
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: json_path
    type: File
    format: "edam:format_3464"
    inputBinding:
      prefix: --json_path

  - id: uuid
    type: string
    inputBinding:
      prefix: --uuid

outputs:
  - id: log
    type: File
    outputBinding:
      glob: $(inputs.uuid +".log")

  - id: output_sqlite
    type: File
    format: "edam:format_3621"
    outputBinding:
      glob: $(inputs.uuid + ".db")         
          
baseCommand: [/usr/local/bin/readgroup_json_db]
