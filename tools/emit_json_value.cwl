#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: InlineJavascriptRequirement

class: ExpressionTool

inputs:
  input:
    type: File
    inputBinding:
      loadContents: true
      valueFrom: $(null)

  key:
    type: string

outputs:
  output:
    type: string

expression: |
  ${
    var output_value = JSON.parse(inputs.input.contents)[inputs.key];
    return {'output': output_value};
  }



