#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: InlineJavascriptRequirement

class: ExpressionTool

inputs:
  - id: load_bucket
    type: string

  - id: filename
    type: string

outputs:
  - id: output
    type: string

expression: |
  ${
    var output = inputs.load_bucket + inputs.filename;
    return {'output': output}
  }
