cwlVersion: v1.0
class: ExpressionTool
id: emit_json_value
requirements:
  - class: InlineJavascriptRequirement

inputs:
  input:
    type: File
    inputBinding:
      loadContents: true
      # valueFrom: $(null)

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
