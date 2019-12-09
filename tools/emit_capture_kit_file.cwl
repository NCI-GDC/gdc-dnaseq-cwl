cwlVersion: v1.0
class: ExpressionTool
id: emit_capture_kit_file
requirements:
  - class: SchemaDefRequirement
    types:
      - $import: target_kit_schema.yml 
  - class: InlineJavascriptRequirement

inputs:
  capture_kit_bait_file:
    type: File

  capture_kit_target_file:
    type: File

outputs:
  output:
    type: target_kit_schema.yml#capture_kit_set_file

expression: |
  ${
    var output = {'capture_kit_bait_file': inputs.capture_kit_bait_file,
                  'capture_kit_target_file': inputs.capture_kit_target_file};
    return {'output': output};
  }
