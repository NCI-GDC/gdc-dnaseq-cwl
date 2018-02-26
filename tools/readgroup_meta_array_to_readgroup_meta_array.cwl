#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - $import: readgroup.yml
  - class: InlineJavascriptRequirement

class: ExpressionTool

inputs:
  - id: input
    type:
      type: array
      items: readgroup.yml#readgroup_meta

outputs:
  - id: output
    type:
      type: array
      items: readgroup.yml#readgroup_meta

expression: |
  ${
    const output = inputs.input;
    return {'output': output};
  }
