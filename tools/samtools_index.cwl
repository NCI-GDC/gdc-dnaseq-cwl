cwlVersion: v1.0
class: CommandLineTool
id: samtools_index
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/samtools:147bd4cc606a63c7435907d97fea6e94e9ea9ed58c18f390cab8bc40b1992df7
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
    format: "edam:format_2572"
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
    format: "edam:format_2572"
    type: File
    outputBinding:
      glob: $(inputs.input_bam.basename)
    secondaryFiles:
      - "^.bai"

baseCommand: [samtools, index, -b]

arguments:
  - valueFrom: $(inputs.input_bam.basename.slice(0,-4) + '.bai')
    position: 2
