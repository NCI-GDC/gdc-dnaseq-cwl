#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: SchemaDefRequirement
    types:
      - $import: readgroup.yml
  - class: InlineJavascriptRequirement

class: ExpressionTool

inputs:
  - id: forward_fastq_list
    format: "edam:format_2182"
    type:
      type: array
      items: File

  - id: reverse_fastq_list
    format: "edam:format_2182"
    type:
      type: array
      items: File

  - id: readgroup_meta_list
    type:
      type: array
      items: readgroup.yml#readgroup_meta

outputs:
  - id: output
    type:
      type: array
      items: readgroup.yml#readgroup_fastq_pe_file

expression: |
  ${
      // /begin william malo / CC-BY-SA-4.0
      // https://stackoverflow.com/a/9849276/810957
      function include(arr,obj) {
        return (arr.indexOf(obj) != -1)
      }
      // /end william malo / CC-BY-SA-4.0

      // /begin chakrit / CC-BY-SA-4.0
      // https://stackoverflow.com/a/2548133/810957
      function endsWith(str, suffix) {
        return str.indexOf(suffix, str.length - suffix.length) !== -1;
      }
      // /end chakrit / CC-BY-SA-4.0

      // /begin 3DFace / CC-BY-SA-4.0
      // https://stackoverflow.com/questions/3820381/need-a-basename-function-in-javascript#comment29942319_15270931
      function local_basename(path) {
        var basename = path.split(/[\\/]/).pop();
        return basename
      }
      // /end 3DFace / CC-BY-SA-4.0

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

    // get readgroup name from fastq
    function fastq_to_rg_id(fq_file_object) {
      var fastq_name = local_basename(fq_file_object.location);
      var slice_number = get_slice_number(fastq_name);
      var readgroup_name = fastq_name.slice(0,slice_number);
      return readgroup_name;
    }

    // get predicted readgroup names from fastq
    var readgroup_name_array = [];
    for (var i = 0; i < inputs.forward_fastq_list.length; i++) {
      var fq = inputs.forward_fastq_list[i];
      var readgroup_name = fastq_to_rg_id(fq);
      readgroup_name_array.push(readgroup_name);
    }

    var actual_readgroup_name_array = [];
    for (var i = 0; i < inputs.readgroup_meta_list.length; i++) {
      var actual_readgroup_name = inputs.readgroup_meta_list[i]["ID"];
      actual_readgroup_name_array.push(actual_readgroup_name);
    }
    
    // ensure predicted readgroup names are in actual list
    for (var i = 0; i < readgroup_name_array.length; i++) {
      var pred_readgroup_name = readgroup_name_array[i];
      if (!(include(actual_readgroup_name_array, pred_readgroup_name))) {
        throw "not recognized pred_readgroup_name"
      }
    }

    // build output
    var output_array = [];
    for (var i = 0; i < inputs.forward_fastq_list.length; i++) {
      var forward_fastq = inputs.forward_fastq_list[i];
      var reverse_fastq = inputs.reverse_fastq_list[i];
      var readgroup_name = fastq_to_rg_id(forward_fastq);
      for (var j = 0; j < inputs.readgroup_meta_list.length; j++) {
        var readgroup_id = inputs.readgroup_meta_list[j]["ID"];
        if (readgroup_name === readgroup_id) {
          var readgroup_meta = inputs.readgroup_meta_list[j];
          break;
        }
      }

      var output = {"forward_fastq": forward_fastq,
                    "reverse_fastq": reverse_fastq,
                    "readgroup_meta": readgroup_meta};
      output.forward_fastq.format = "edam:format_2182";
      output.reverse_fastq.format = "edam:format_2182";
      output_array.push(output);
    }
    
    return {'output': output_array}
  }
