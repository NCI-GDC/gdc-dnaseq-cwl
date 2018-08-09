#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/fastq_cleaner:64142d0aae2327d0bdf1872c8e17e158e966f84fc0c3fd9ff647794e234ccd6d
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 2000
    ramMax: 2000
    tmpdirMin: $(Math.ceil(1.1 * inputs.fastq.size / 1048576))
    tmpdirMax: $(Math.ceil(1.1 * inputs.fastq.size / 1048576))
    outdirMin: $(Math.ceil(1.1 * inputs.fastq.size / 1048576))
    outdirMax: $(Math.ceil(1.1 * inputs.fastq.size / 1048576))

class: CommandLineTool

inputs:
  - id: fastq
    type: File
    format: "edam:format_2182"
    inputBinding:
      prefix: --fastq

  - id: reads_in_memory
    type: long
    default: 500000
    inputBinding:
      prefix: --reads_in_memory

outputs:
  - id: cleaned_fastq
    type: File
    format: "edam:format_2182"
    outputBinding:
      glob: $(inputs.fastq.basename)

  - id: result_json
    type: File
    format: "edam:format_3464"
    outputBinding:
      glob: "result.json"

baseCommand: [/usr/local/bin/fastq_cleaner]
