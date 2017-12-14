#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: InlineJavascriptRequirement

class: ExpressionTool

inputs:
  - id: input
    type: string

  - id: key
    type: string

outputs:
  - id: output
    type: string

expression: |
  ${
    var output_value = inputs.input[inputs.key];
    return {'output': output_value}
  }



