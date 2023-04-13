cwlVersion: v1.0
class: CommandLineTool
id: samtools_idxstats
requirements:
  - class: DockerRequirement
    dockerPull: "{{ docker_repo }}/samtools:{{ samtools }}"
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 5000
    ramMax: 5000
    tmpdirMin: 5
    tmpdirMax: 5
    outdirMin: 5
    outdirMax: 5

inputs:
  INPUT:
    type: File
    inputBinding:
      position: 0
    secondaryFiles:
      - ^.bai

outputs:
  OUTPUT:
    type: File
    outputBinding:
      glob: $(inputs.INPUT.nameroot + ".idxstats")

stdout: $(inputs.INPUT.nameroot + ".idxstats")

baseCommand: [/usr/local/bin/samtools, idxstats]
