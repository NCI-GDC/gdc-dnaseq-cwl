cwlVersion: v1.0
class: CommandLineTool
id: samtools_stats
requirements:
  - class: DockerRequirement
    dockerPull: "{{ docker_repo }}/samtools:{{ samtools }}"
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: $(inputs.threads)
    ramMin: 5000
    tmpdirMin: 5
    outdirMin: 5

inputs:
  INPUT:
    type: File
    inputBinding:
      position: 1

  threads:
    type: long
    inputBinding:
      position: 0
      prefix: -@

outputs:
  OUTPUT:
    type: File
    outputBinding:
      glob: $(inputs.INPUT.nameroot + ".stats")

stdout: $(inputs.INPUT.nameroot + ".stats")

baseCommand: [/usr/local/bin/samtools, stats]
