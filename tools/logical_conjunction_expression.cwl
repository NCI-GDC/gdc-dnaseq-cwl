#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: InlineJavascriptRequirement

class: ExpressionTool

inputs:
  - id: values
    type:
      type: array
      items: boolean

outputs:
  - id: result
    type: boolean

expression: |
   ${
      var result = true;

      for (var i = 0; i < inputs.values.length; i++) {
        result = result && inputs.values[i];
      }
      return {'result': result}
    }
