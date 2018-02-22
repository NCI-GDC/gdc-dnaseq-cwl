#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - $import: readgroup.yml
  - class: InlineJavascriptRequirement

class: ExpressionTool

inputs:
  - id: capture_kit_bait_file
    type:
      type: array
      items: File

  - id: capture_kit_target_file
    type:
      type: array
      items: File

  - id: readgroup_meta
    type: readgroup.yml#readgroup_meta

outputs:
  - id: output
    type: readgroup.yml#readgroup_meta

expression: |
  ${
    var readgroup_meta = inputs.readgroup_meta;
    readgroup_meta.capture_kit_bait_file = inputs.capture_kit_bait_file;
    readgroup_meta.capture_kit_target_file = inputs.capture_kit_target_file;
    return {'output': readgroup_meta};
  }
