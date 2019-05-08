#!/usr/bin/env cwl-runner
#$namespaces:"
  #edam: "http://edamontology.org/"
cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/gatk:3e1abbee6d5719839b1097a7fe457a571fd20f96c50028af52756f084d512278
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: input
    format: "edam:format_2572"
    type: File
    inputBinding:
      prefix: --input
    secondaryFiles:
      - ^.bai

  - id: tmp_dir
    type: string
    default: "."
    inputBinding:
      prefix: --tmp-dir

  - id: variant
    type: File
    inputBinding:
      prefix: --variant

  - id: intervals
    type: File
    inputBinding:
      prefix: --intervals

outputs:
  - id: output
    type: File
    outputBinding:
      glob: $(inputs.input.nameroot + "_pileupsummaries.table")

arguments:
  - valueFrom: $(inputs.input.nameroot + "_pileupsummaries.table")
    prefix: --output
    separate: true

baseCommand: [java, -jar, /usr/local/bin/gatk-package-4.1.2.0-local.jar, GetPileupSummaries]
