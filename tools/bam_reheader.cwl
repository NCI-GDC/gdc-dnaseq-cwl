#!/usr/bin/env cwl-runner
#$namespaces:"
  #edam: "http://edamontology.org/"
cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/bam_reheader:e4f989684b19a9850003022cd9e2e1b931e0c249f8e4a97fe0ed3537851c5507
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 10000
    ramMax: 10000
    tmpdirMin: $(Math.ceil(1.1 * inputs.input.size / 1048576))
    tmpdirMax: $(Math.ceil(1.1 * inputs.input.size / 1048576))
    outdirMin: $(Math.ceil(1.1 * inputs.input.size / 1048576))
    outdirMax: $(Math.ceil(1.1 * inputs.input.size / 1048576))

class: CommandLineTool

inputs:
  - id: input
    type: File
    format: "edam:format_2572"
    inputBinding:
      prefix: --bam_path

  - id: header
    type: File
    inputBinding:
      prefix: --header_path

outputs:
  - id: output
    type: File
    format: "edam:format_2572"
    outputBinding:
      glob: $(inputs.input.basename)

  - id: log
    type: File
    outputBinding:
      glob: $(inputs.input.basename + ".log")

baseCommand: [/usr/local/bin/bam_reheader]
