cwlVersion: v1.0
class: CommandLineTool
id: readgroup_json_db
requirements:
  - class: DockerRequirement
    dockerPull: "{{ docker_repo }}/readgroup_json_db:{{ readgroup_json_db }}"
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
    outputBinding:
      glob: $(inputs.job_uuid + ".db")

baseCommand: [/usr/local/bin/readgroup_json_db]
