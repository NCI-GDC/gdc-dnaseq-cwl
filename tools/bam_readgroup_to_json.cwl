cwlVersion: v1.0
class: CommandLineTool
id: bam_readgroup_to_json
requirements:
  - class: DockerRequirement
    dockerPull: "{{ docker_repo }}/bam_readgroup_to_json:{{ bam_readgroup_to_json }}"
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
  INPUT:
    type: File
    inputBinding:
      prefix: --bam_path

  MODE:
    type: string
    default: strict
    inputBinding:
      prefix: --mode

outputs:
  OUTPUT:
    type:
      type: array
      items: File
    outputBinding:
      glob: "*.json"
      outputEval: |
        ${ return self.sort(function(a,b) { return a.location > b.location ? 1 : (a.location < b.location ? -1 : 0) }) }

  log:
    type: File
    outputBinding:
      glob: "output.log"

baseCommand: [/usr/local/bin/bam_readgroup_to_json]
