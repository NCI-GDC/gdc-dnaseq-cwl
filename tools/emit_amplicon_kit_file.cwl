cwlVersion: v1.0
class: ExpressionTool
id: emit_amplicon_kit_file
requirements:
  - class: SchemaDefRequirement
    types:
      - $import: target_kit_schema.yml
  - class: InlineJavascriptRequirement

inputs:
  amplicon_kit_amplicon_file:
    type: File

  amplicon_kit_target_file:
    type: File

outputs:
  output:
    type: target_kit_schema.yml#amplicon_kit_set_file

expression: |
  ${
    var output = {'amplicon_kit_amplicon_file': inputs.amplicon_kit_amplicon_file,
                  'amplicon_kit_target_file': inputs.amplicon_kit_target_file};
    return {'output': output};
  }
