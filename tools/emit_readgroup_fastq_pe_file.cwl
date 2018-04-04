#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: SchemaDefRequirement
    types:
      - $import: readgroup.yml
  - class: InlineJavascriptRequirement

class: ExpressionTool

inputs:
  - id: forward_fastq
    type: File

  - id: reverse_fastq
    type: File

  - id: readgroup_meta
    type: readgroup.yml#readgroup_meta

outputs:
  - id: output
    type: readgroup.yml#readgroup_fastq_pe_file

expression: |
  ${
    var output = { "forward_fastq": inputs.forward_fastq,
                     "reverse_fastq": inputs.reverse_fastq,
                     "readgroup_meta": inputs.readgroup_meta
                    };
    return {'output': output}
  }
