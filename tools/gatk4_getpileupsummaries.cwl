cwlVersion: v1.0
class: CommandLineTool
id: gatk4_getpileupsummaries
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

  tmp_dir:
    type: string
    default: "."
    inputBinding:
      prefix: --TMP_DIR

  variant:
    type: File
    inputBinding:
      prefix: --variant

  reference:
    type: File
    inputBinding:
      prefix: -R

outputs:
  output:
    type: File
    outputBinding:
      glob: $(inputs.input.nameroot + "_pileupsummaries.table")

arguments:
  - valueFrom: $(inputs.input.nameroot + "_pileupsummaries.table")
    prefix: --output
    separate: true

baseCommand: [java, -jar, /usr/local/bin/gatk-package-4.0.7.0-local.jar, GetPileupSummaries]
