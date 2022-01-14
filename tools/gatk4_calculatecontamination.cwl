cwlVersion: v1.0
class: CommandLineTool
id: gatk4_calculatecontamination
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gatk:4.2.4.1
  - class: InlineJavascriptRequirement

inputs:
  input:
    type: File
    inputBinding:
      prefix: --input

  tmp_dir:
    type: string
    default: "."
    inputBinding:
      prefix: --tmp-dir

  bam_nameroot:
    type: string

outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.bam_nameroot + "_contamination.table")

arguments:
  - valueFrom: $(inputs.bam_nameroot + "_contamination.table")
    prefix: --output
    separate: true

baseCommand: [CalculateContamination]
