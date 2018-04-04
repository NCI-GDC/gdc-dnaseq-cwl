#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: InlineJavascriptRequirement
  - class: SchemaDefRequirement
    types:
      - $import: readgroup.yml

class: ExpressionTool

inputs:
  - id: fastq
    type: File

  - id: readgroup_meta
    type: readgroup.yml#readgroup_meta

outputs:
  - id: output
    type: readgroup.yml#readgroup_fastq_se_file

expression: |
  ${
    var output = { "fastq": inputs.fastq,
                     "readgroup_meta": inputs.readgroup_meta};

    return {'output': output}
  }
