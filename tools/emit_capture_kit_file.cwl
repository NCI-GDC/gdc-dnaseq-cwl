#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: SchemaDefRequirement
    types:
      - $import: capture_kit.yml
  - class: InlineJavascriptRequirement

class: ExpressionTool

inputs:
  - id: capture_kit_bait_file
    type: File

  - id: capture_kit_target_file
    type: File

outputs:
  - id: output
    type: capture_kit.yml#capture_kit_set_file

expression: |
  ${
    var output = {'capture_kit_bait_file': inputs.capture_kit_bait_file,
                  'capture_kit_target_file': inputs.capture_kit_target_file};
    return {'output': output};
  }
