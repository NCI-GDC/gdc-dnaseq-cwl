#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - $import: readgroup.yaml
  - class: InlineJavascriptRequirement

class: ExpressionTool

inputs:
  - id: readgroup_meta_list
    type:
      type: array
      items: readgroup.yaml#readgroup_meta

  - id: bam_readgroup_json
    type: File
    inputBinding:
      loadContents: true
      valueFrom: $(null)

outputs:
  - id: output
    type: boolean

expression: |
  ${
    var found_readgroup = false;
    const readgroup_json = JSON.parse(inputs.bam_readgroup_json.contents);

    function check_readgroup(readgroup_json, readgroup_meta) {
      var output = true;
      const rg_identifiers = ["CN", "ID", "LB", "PL", "SM"];
      for (var j in rg_identifiers) {
        var rgi = rg_identifiers[j];
        if (readgroup_meta[rgi].toUpperCase() != readgroup_json[rgi].toUpperCase()) {
          output = output && false;
        }
      }
      return output;
    }

    for (var i in inputs.readgroup_meta_list) {
      if (readgroup_json['ID'] == inputs.readgroup_meta_list[i]['ID']) {
        found_readgroup = true;
        output = check_readgroup(readgroup_json, inputs.readgroup_meta_list[i]);
      }
    }

    if (!found_readgroup) {
      return
    }

    return {'output': output}
  }
