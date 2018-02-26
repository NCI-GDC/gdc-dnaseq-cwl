#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: InlineJavascriptRequirement

class: ExpressionTool

inputs:
  - id: input
    type:
      type: array
      items: File

outputs:
  - id: output
    type:
      type: array
      items: File

expression: |
  ${
    const output = inputs.input;
    return {'output': output};
  }
