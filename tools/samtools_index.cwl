cwlVersion: v1.0
class: CommandLineTool
id: samtools_index
requirements:
  - class: DockerRequirement
    dockerPull: "{{ docker_repo }}/samtools:{{ samtools }}"
  - class: InitialWorkDirRequirement
    listing:
      - entry: $(inputs.input_bam)
        writable: false
  - class: InlineJavascriptRequirement
    expressionLib:
      $import: ./expression_lib.cwl
  - class: ResourceRequirement
    coresMin: $(inputs.threads)
    ramMin: 1000
    tmpdirMin: $(file_size_multiplier(inputs.input_bam))
    outdirMin: $(file_size_multiplier(inputs.input_bam))

inputs:
  input_bam:
    type: File
    inputBinding:
      position: 1
      valueFrom: $(self.basename)

  threads:
    type: long
    inputBinding:
      position: 0
      prefix: -@

outputs:
  output_bam:
    type: File
    outputBinding:
      glob: $(inputs.input_bam.basename)
    secondaryFiles:
      - "^.bai"

baseCommand: [samtools, index, -b]

arguments:
  - valueFrom: $(inputs.input_bam.basename.slice(0,-4) + '.bai')
    position: 2
