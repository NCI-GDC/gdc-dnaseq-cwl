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

  - id: task_uuid
    type: string

outputs:
  - id: output
    type: string

expression: |
  ${
    var output = inputs.load_bucket + "/" + inputs.task_uuid + "/" + inputs.filename;
    return {'output': output}
  }
