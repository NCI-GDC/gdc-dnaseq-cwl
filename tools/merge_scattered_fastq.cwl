#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: InlineJavascriptRequirement

class: ExpressionTool

inputs:
  - id: INPUT
    format: "edam:format_2182"
    type:
      type: array
      items: File

outputs:
  - id: OUTPUT
    format: "edam:format_2182"
    type:
      type: array
      items: File

expression: |
   ${
      var output = inputs.INPUT.sort(function(a,b) { return a.basename > b.basename } )

      return {'OUTPUT': output}
    }
