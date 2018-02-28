#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: InlineJavascriptRequirement
  - class: SchemaDefRequirement
    types:
      - $import: readgroup.yml

class: ExpressionTool

inputs:
  - id: readgroup_meta
    type: readgroup.yml#readgroup_meta

  - id: readgroup_meta_list
    type:
      type: array
      items: readgroup.yml#readgroup_meta

outputs:
  - id: output
    type: readgroup.yml#readgroup_meta

expression: |
  ${
    for (var i = 0; i < inputs.readgroup_meta_list.length; i++) {
      var readgroup_meta_kit = inputs.readgroup_meta_list[i];
      if (inputs.readgroup_meta['ID'] == readgroup_meta_kit['ID']) {
        var meta = inputs.readgroup_meta;
        meta['capture_kit_bait_uuid'] = readgroup_meta_kit['capture_kit_bait_uuid'];
        meta['capture_kit_bait_file'] = readgroup_meta_kit['capture_kit_bait_file'];
        meta['capture_kit_target_uuid'] = readgroup_meta_kit['capture_kit_target_uuid'];
        meta['capture_kit_target_file'] = readgroup_meta_kit['capture_kit_target_file'];
        return {'output': meta}
      }
    }

    var meta = inputs.readgroup_meta;
    meta['capture_kit_bait_uuid'] = [];
    meta['capture_kit_bait_file'] = [];
    meta['capture_kit_target_uuid'] = [];
    meta['capture_kit_target_file'] = [];
    return {'output': meta}
  }
