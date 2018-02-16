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
    var reqkeys = ["CN", "DS", "DT", "FO", "ID", "KS", "LB", "PI", "PL", "PM", "PU", "SM"];
    const readgroup = JSON.parse(inputs.input.contents);
    var output = new Object();
    for (var i in readgroup) {
      output[i] = readgroup[i];
    }
    for (var j in reqkeys) {
      if (!(reqkeys[j] in output)) {
        output[reqkeys[j]] = null;
      }
    }

    return {'output': output};
  }
