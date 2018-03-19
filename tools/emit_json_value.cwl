#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: InlineJavascriptRequirement

class: ExpressionTool

inputs:
  - id: input
    type: File
    inputBinding:
      loadContents: true
      valueFrom: $(null)

  - id: key
    type: string

outputs:
  - id: output
    type: string

expression: |
  ${
    var output_value = JSON.parse(inputs.input.contents)[inputs.key];
    return {'output': output_value};
  }



