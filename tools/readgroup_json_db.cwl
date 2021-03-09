cwlVersion: v1.0
class: CommandLineTool
id: readgroup_json_db
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/readgroup_json_db:d1c36c48491afa45c76c23624ecf69b37b4f276019cb6e168364f564452e5b37
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

inputs:
  json_path:
    type: File
    format: "edam:format_3464"
    inputBinding:
      prefix: --json_path

  job_uuid:
    type: string
    inputBinding:
      prefix: --job_uuid

outputs:
  log:
    type: File
    outputBinding:
      glob: $(inputs.job_uuid +".log")

  output_sqlite:
    type: File
    format: "edam:format_3621"
    outputBinding:
      glob: $(inputs.job_uuid + ".db")         
          
baseCommand: [/usr/local/bin/readgroup_json_db]
