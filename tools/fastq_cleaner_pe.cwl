#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/fastq_cleaner:08f5f8a6bc2c7be523993ccea7d3e1dc6eb1553c8feb4db171d958107d64bd7c
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 2
    coresMax: 2
    ramMin: 2000
    ramMax: 2000
    tmpdirMin: $(Math.ceil(1.1 * (inputs.fastq1.size + inputs.fastq2.size) / 1048576))
    tmpdirMax: $(Math.ceil(1.1 * (inputs.fastq1.size + inputs.fastq2.size) / 1048576))
    outdirMin: $(Math.ceil(1.1 * (inputs.fastq1.size + inputs.fastq2.size) / 1048576))
    outdirMax: $(Math.ceil(1.1 * (inputs.fastq1.size + inputs.fastq2.size) / 1048576))

class: CommandLineTool

inputs:
  - id: fastq1
    type: File
    format: "edam:format_2182"
    inputBinding:
      prefix: --fastq

  - id: fastq2
    type: File
    format: "edam:format_2182"
    inputBinding:
      prefix: --fastq2

  - id: reads_in_memory
    type: long
    default: 500000
    inputBinding:
      prefix: --reads_in_memory

outputs:
  - id: cleaned_fastq1
    type: File
    format: "edam:format_2182"
    outputBinding:
      glob: $(inputs.fastq1.basename)

  - id: cleaned_fastq2
    type: File
    format: "edam:format_2182"
    outputBinding:
      glob: $(inputs.fastq2.basename)

  - id: result_json
    type: File
    format: "edam:format_3464"
    outputBinding:
      glob: "result.json"

baseCommand: [/usr/local/bin/fastq_cleaner]
