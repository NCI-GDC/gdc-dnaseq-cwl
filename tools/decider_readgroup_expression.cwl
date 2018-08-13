#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: InlineJavascriptRequirement

class: ExpressionTool

inputs:
  - id: fastq
    format: "edam:format_2182"
    type:
      type: array
      items: File

  - id: readgroup_json
    format: "edam:format_3464"
    type:
      type: array
      items: File

outputs:
  - id: output
    format: "edam:format_3464"
    type:
      type: array
      items: File

expression: |
   ${

      // https://stackoverflow.com/a/9849276/810957
      function include(arr,obj) {
        return (arr.indexOf(obj) != -1)
      }

      // https://stackoverflow.com/a/2548133/810957
      function endsWith(str, suffix) {
        return str.indexOf(suffix, str.length - suffix.length) !== -1;
      }

      // https://stackoverflow.com/questions/3820381/need-a-basename-function-in-javascript#comment29942319_15270931
      function local_basename(path) {
        var basename = path.split(/[\\/]/).pop();
        return basename
      }

      // https://planetozh.com/blog/2008/04/javascript-basename-and-dirname/
      function local_dirname(path) {
        return path.replace(/\\/g,'/').replace(/\/[^\/]*$/, '');
      }

      function get_slice_number(fastq_name) {
        if (endsWith(fastq_name, '_1.fq.gz')) {
          return -8
        }
        else if (endsWith(fastq_name, '_s.fq.gz')) {
          return -8
        }
        else if (endsWith(fastq_name, '_o1.fq.gz')) {
          return -9
        }
        else if (endsWith(fastq_name, '_o2.fq.gz')) {
          return -9
        }
        else {
          throw "not recognized fastq suffix"
        }
      }
      
      // get predicted readgroup basenames from fastq
      var readgroup_basename_array = [];
      for (var i = 0; i < inputs.fastq.length; i++) {
        var fq_path = inputs.fastq[i];
        var fq_name = local_basename(fq_path.location);

        var slice_number = get_slice_number(fq_name);
        
        var readgroup_name = fq_name.slice(0,slice_number) + ".json";
        readgroup_basename_array.push(readgroup_name);
      }

      // find which readgroup items are in predicted basenames
      var readgroup_array = [];
      for (var i = 0; i < inputs.readgroup_json.length; i++) {
        var readgroup = inputs.readgroup_json[i];
        var readgroup_basename = local_basename(readgroup.location);
        if (include(readgroup_basename_array, readgroup_basename)) {
          readgroup_array.push(readgroup);
        }
      }

      var readgroup_sorted = readgroup_array.sort(function(a,b) { return a.location > b.location ? 1 : (a.location < b.location ? -1 : 0) });
      return {'output': readgroup_sorted}
    }
