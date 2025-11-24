
cwlVersion: v1.0
class: CommandLineTool
id: fastqc_basicstatistics_json
requirements:
  - class: InlineJavascriptRequirement
  - class: DockerRequirement
    dockerPull: "{{ docker_repo }}/fastqc_to_json:{{ fastqc_to_json }}"
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
#  sqlite_path:
#    type: File
#    inputBinding:
#      prefix: --sqlite_path

  sqlite_path:
    type: File
    inputBinding:
      valueFrom: "--sqlite_path=$(self.path)"
      position: 1
      shellQuote: false

outputs:
  OUTPUT:
    type: File
    outputBinding:
      glob: "fastqc.json"

baseCommand: []
