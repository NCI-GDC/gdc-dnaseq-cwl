#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: InlineJavascriptRequirement

class: ExpressionTool

inputs:
  - id: input
    type: File

  - id: format
    type: string
      
outputs:
  - id: output
    type: File

expression: |
  ${
    var output = inputs.input;
    output.format = inputs.format;
    return {'output': output}
  }
