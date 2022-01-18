cwlVersion: v1.0
class: CommandLineTool
id: gatk4_baserecalibrator
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gatk:4.2.4.1
  - class: InlineJavascriptRequirement

inputs:
  input:
    type: File
    inputBinding:
      prefix: --input
    secondaryFiles:
      - ^.bai

  known-sites:
    type: File
    inputBinding:
      prefix: --known-sites
    secondaryFiles:
      - .tbi

  reference:
    type: File
    inputBinding:
      prefix: --reference
    secondaryFiles:
      - .fai
      - ^.dict

  tmp_dir:
    type: string
    default: "."
    inputBinding:
      prefix: --tmp-dir

outputs:
  output_grp:
    type: File
    outputBinding:
      glob: $(inputs.input.nameroot + "_bqsr.grp")

arguments:
  - valueFrom: $(inputs.input.nameroot + "_bqsr.grp")
    prefix: --output
    separate: true

baseCommand: [BaseRecalibrator]
