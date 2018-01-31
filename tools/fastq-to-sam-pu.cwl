#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/fastq-to-sam-pu:latest
  - class: InlineJavascriptRequirement

class: CommandLineTool

inputs:
  - id: fastq_path
    type: File
    inputBinding:
      prefix: --fastq_path

outputs:
  - id: output
    type: string
    outputBinding:
      glob: $(inputs.fastq_path.nameroot).pu.out
      loadContents: true
      outputEval: $(self[0].contents)

stdout: $(inputs.fastq_path.nameroot).pu.out

baseCommand: [/usr/local/bin/fastq_to_SAM_PU]
