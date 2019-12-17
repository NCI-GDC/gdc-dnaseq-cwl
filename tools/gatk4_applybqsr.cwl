cwlVersion: v1.0
class: CommandLineTool
id: gatk4_applybqsr
requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gatk:a4a89bba62c91fec4b79b38a55d8a9353f503df0a55dd3950c7b3da640b1c6cf
  - class: InlineJavascriptRequirement

inputs:
  input:
    format: "edam:format_2572"
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
      prefix: --TMP_DIR

outputs:
  output_bam:
    format: "edam:format_2572"
    type: File
    outputBinding:
      glob: $(inputs.input.basename)
    secondaryFiles:
      - ^.bai

arguments:
  - valueFrom: $(inputs.input.basename)
    prefix: --output

baseCommand: [java, -jar, /usr/local/bin/gatk-package-4.0.7.0-local.jar, ApplyBQSR]
