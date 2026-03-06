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

baseCommand: [samtools, sort]

inputs:
  threads:
    type: long
    inputBinding:
      position: 0
      prefix: -@

  sort_mem:
    type: string
    default: "5G"
    inputBinding:
      position: 1
      prefix: -m

  output_bam:
    type: string
    inputBinding:
      position: 2
      prefix: -o

  prefix:
    type: string
    default: "tmp_srt"
    inputBinding:
      position: 3
      prefix: -T

  input_bam:
    type: File
    inputBinding:
      position: 4

outputs:
  bam:
    type: File
    outputBinding:
      glob: $(inputs.output_bam)

