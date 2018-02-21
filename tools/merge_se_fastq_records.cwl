#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - $import: readgroup.yml

class: ExpressionTool

inputs:
  - id: input
    type:
      type: array
      items:
        type: array
        items: readgroup.yml#readgroup_fastq_se_file

outputs:
  - id: output
    type:
      type: array
      items: readgroup.yml#readgroup_fastq_se_file

expression: |
  ${
    var output = [];
    for (var readgroup_array in inputs.input) {
      for (var readgroup in readgroup_array) {
        output.push(readgroup);
      }
    }

    return {'output': output}
  }
