#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: InlineJavascriptRequirement

class: ExpressionTool

inputs:
  - id: input
    type:
      type: array
      items: string

outputs:
  - id: output
    type:
      type: array
      items: string

expression: |
  ${
    const output = inputs.input;
    return {'output': output};
  }
