#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: InlineJavascriptRequirement

class: ExpressionTool

inputs:
  - id: filearray
    type:
      type: array
      items: File

  - id: filename
    type: string

outputs:
  - id: output
    type: File

expression: |
   ${
      // /begin william malo / CC-BY-SA-4.0
      // https://stackoverflow.com/a/9849276/810957
      function include(arr,obj) {
        return (arr.indexOf(obj) != -1)
      }
      // /end william malo / CC-BY-SA-4.0

      // /begin 3DFace / CC-BY-SA-4.0
      // https://stackoverflow.com/questions/3820381/need-a-basename-function-in-javascript#comment29942319_15270931
      function local_basename(path) {
        var basename = path.split(/[\\/]/).pop();
        return basename
      }
      // /end 3DFace / CC-BY-SA-4.0

      // get filepath using filename
      for (var i = 0; i < inputs.filearray.length; i++) {
        var this_file = inputs.filearray[i];
        var this_basename = local_basename(this_file.location);
        if (include(inputs.filename, this_basename)) {
          return {'output' : this_file }
        }
      }
    }
