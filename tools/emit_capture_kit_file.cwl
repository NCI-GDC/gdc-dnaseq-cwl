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

  - id: capture_kit_set
    type: capture_kit.yml#capture_kit_set

outputs:
  - id: output
    type: capture_kit.yml#capture_kit_set

expression: |
  ${
    var capture_kit_set = inputs.capture_kit_set;
    capture_kit_set.capture_kit_bait_file = inputs.capture_kit_bait_file;
    capture_kit_set.capture_kit_target_file = inputs.capture_kit_target_file;
    return {'output': capture_kit_set};
  }
