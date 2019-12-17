cwlVersion: v1.0
class: CommandLineTool
id: samtools_sort
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/samtools:147bd4cc606a63c7435907d97fea6e94e9ea9ed58c18f390cab8bc40b1992df7
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: $(inputs.threads)
    ramMin: 1000
    tmpdirMin: $((2 * inputs.input_bam.size) / 1048576)
    outdirMin: $((2 * inputs.input_bam.size) / 1048576)

inputs:
  input_bam:
    format: "edam:format_2572"
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
    format: "edam:format_2572"
    type: File
    outputBinding:
      glob: $(inputs.output_bam)

baseCommand: [samtools, sort]
