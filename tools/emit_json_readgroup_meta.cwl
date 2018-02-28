#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - $import: readgroup.yml
  - class: InlineJavascriptRequirement

class: ExpressionTool

inputs:
  - id: input
    type: File
    inputBinding:
      loadContents: true
      valueFrom: $(null)

outputs:
  - id: output
    type: readgroup.yml#readgroup_meta

expression: |
  ${
    const readgroup = JSON.parse(inputs.input.contents);
    var output = new Object();
    for (var i in readgroup) {
      if (i.length == 2) {
        if (i == 'PL') {
          output[i] = readgroup[i].toUpperCase();
        } else {
          output[i] = readgroup[i];
        }
      }
    }
    output['capture_kit_bait_uuid'] = [];
    output['capture_kit_bait_file'] = [];
    output['capture_kit_target_uuid'] = [];
    output['capture_kit_target_file'] = [];

    return {'output': output};
  }
