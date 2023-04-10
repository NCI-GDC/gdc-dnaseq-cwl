cwlVersion: v1.0
class: CommandLineTool
id: samtools_sort
requirements:
  - class: DockerRequirement
    dockerPull: "{{ docker_repo }}/samtools:{{ samtools }}"
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: $(inputs.threads)
    ramMin: 1000
    tmpdirMin: $(Math.ceil((2 * inputs.input_bam.size) / 1048576))
    outdirMin: $(Math.ceil((2 * inputs.input_bam.size) / 1048576))

inputs:
  input_bam:
    type: File
    inputBinding:
      position: 3

  output_bam:
    type: string
    inputBinding:
      position: 1
      prefix: -o

  threads:
    type: long
    inputBinding:
      position: 0
      prefix: -@

  prefix:
    type: string
    default: "tmp_srt"
    inputBinding:
      position: 2
      prefix: -T

outputs:
  bam:
    type: File
    outputBinding:
      glob: $(inputs.output_bam)

baseCommand: [samtools, sort]
