#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/fastq-to-sam-pu:455c68b6b3345f7c0c1e7d21430da82a270560f874489e9059e28cf3cac20612
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
      outputEval: $(self[0].contents.trim())

stdout: $(inputs.fastq_path.nameroot).pu.out

baseCommand: [/usr/local/bin/fastq_to_SAM_PU]
