cwlVersion: v1.0
class: CommandLineTool
id: gatk4_applybqsr
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

  bqsr-recal-file:
    type: File
    inputBinding:
      prefix: --bqsr-recal-file

  emit-original-quals:
    type:
      - type: enum
        symbols: ["true", "false"]
    default: "true"
    inputBinding:
      prefix: --emit-original-quals

  tmp_dir:
    type: string
    default: "."
    inputBinding:
      prefix: --tmp-dir

outputs:
  output_bam:
    type: File
    outputBinding:
      glob: $(inputs.input.basename)
    secondaryFiles:
      - ^.bai

arguments:
  - valueFrom: $(inputs.input.basename)
    prefix: --output

baseCommand: [ApplyBQSR]