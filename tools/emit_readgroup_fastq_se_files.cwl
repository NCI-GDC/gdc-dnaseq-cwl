#!/usr/bin/env cwl-runner
$namespaces:
  edam: "http://edamontology.org/"
cwlVersion: v1.0

requirements:
  - class: SchemaDefRequirement
    types:
      - $import: readgroup.yml
  - class: InlineJavascriptRequirement

class: ExpressionTool

inputs:
  - id: bam_readgroup_json_paths
    format: "edam:format_3464"
    type:
      type: array
      items: File
      inputBinding:
        loadContents: true

  - id: fastq_list
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
      items: readgroup.yml#readgroup_fastq_se_file

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

      // get PU from json files
      function get_bam_pu(fastq_rgname) {
        console.log("\t\tget_bam_pu() fastq_rgname: " + fastq_rgname);
        for (var i = 0; i < inputs.bam_readgroup_json_paths.length; i++) {
          console.log("\t\tget_bam_pu() i: " + i);
          console.log("\t\tget_bam_pu() inputs.bam_readgroup_json_paths: " + inputs.bam_readgroup_json_paths);
          console.log("\t\tget_bam_pu() inputs.bam_readgroup_json_paths[i]: " + inputs.bam_readgroup_json_paths[i]);
          console.log("\t\tget_bam_pu() inputs.bam_readgroup_json_paths[i].contents: " + inputs.bam_readgroup_json_paths[i].contents);
          console.log("\t\tget_bam_pu() inputs.bam_readgroup_json_paths[i].location: " + inputs.bam_readgroup_json_paths[i].location);
          console.log("\t\tget_bam_pu() inputs.bam_readgroup_json_paths[i].size: " + inputs.bam_readgroup_json_paths[i].size);
          console.log("\t\tget_bam_pu() inputs.bam_readgroup_json_paths[i].class: " + inputs.bam_readgroup_json_paths[i].class);
          var bam_rgdata =  JSON.parse(inputs.bam_readgroup_json_paths[i].contents);
          console.log("\t\tget_bam_pu() bam_rgdata: " + bam_rgdata);
          if (!('PU' in bam_rgdata)) {
            throw "BAM RG does not contain PU.";
          }
          if (fastq_rgname == bam_rgdata['ID']) {
            console.log("\t\tget_bam_pu() fastq_rgname: " + fastq_rgname);
            console.log("\t\tget_bam_pu() bam_rgdata['ID']: " + bam_rgdata['ID']);
            console.log("\t\tget_bam_pu() bam_rgdata['PU']: " + bam_rgdata['PU']);
            return bam_rgdata['PU'];
          }
        }
        throw "BAM RG not found";
      }

      // get readgroup names from fastq
      var fastq_rgname_array = [];
      for (var i = 0; i < inputs.fastq_list.length; i++) {
        var fq = inputs.fastq_list[i];
        var readgroup_name = fastq_to_rg_id(fq);
        fastq_rgname_array.push(readgroup_name);
      }

      var graph_rgname_array = [];
      for (var i = 0; i < inputs.readgroup_meta_list.length; i++) {
        var graph_readgroup_name = inputs.readgroup_meta_list[i]["ID"];
        graph_rgname_array.push(graph_readgroup_name);
      }

      // test if fastq readgroup names are in graph readgroup names
      // failing that, test if bam PU values are in
      // graph ID values
      var use_fastq_name = false;
      var use_bam_pu_value = false;
      console.log("testing:");
      for (var i = 0; i < fastq_rgname_array.length; i++) {
        var fastq_rgname = fastq_rgname_array[i];
        console.log("\n\tfastq_rgname: " + fastq_rgname);
        console.log("\tgraph_rgname_array: " + graph_rgname_array);
        if (!(include(graph_rgname_array, fastq_rgname))) {
          var bam_rgpu = get_bam_pu(fastq_rgname);
          console.log("\tbam_rgpu: " + bam_rgpu);
          if (include(graph_rgname_array, bam_rgpu)) {
            use_bam_pu_value = true;
          }
          else {
            throw "BAM RG PU not found in Graph read_group_names";
          }
        }
        else {
          use_fastq_name = true;
        }
      }

        // build output
        console.log("\nbuilding:");
        var output_array = [];
        if (use_fastq_name) {
          for (var i = 0; i < inputs.fastq_list.length; i++) {
            var fastq = inputs.fastq_list[i];
            var fq_readgroup_name = fastq_to_rg_id(fastq);
            for (var j = 0; j < inputs.readgroup_meta_list.length; j++) {
              var readgroup_id = inputs.readgroup_meta_list[j]["ID"];
              if (fq_readgroup_name === readgroup_id) {
                var readgroup_meta = inputs.readgroup_meta_list[j];
                break;
              }
            }

            var output = {"fastq": fastq,
                          "readgroup_meta": readgroup_meta};
            output.fastq.format = "edam:format_2182";
            output_array.push(output);
          }
        }
        else if (use_bam_pu_value) {
          for (var i = 0; i < inputs.fastq_list.length; i++) {
            var fastq = inputs.fastq_list[i];
            var fastq_rgname = fastq_to_rg_id(fastq);
            var bam_rgpu = get_bam_pu(fastq_rgname, inputs.bam_readgroup_json_paths);
            for (var j = 0; j < inputs.readgroup_meta_list.length; j++) {
              var readgroup_id = inputs.readgroup_meta_list[j]["ID"];
              if (bam_rgpu === readgroup_id) {
                var readgroup_meta = inputs.readgroup_meta_list[j];
                break;
              }
            }
            var output = {"fastq": fastq,
                          "readgroup_meta": readgroup_meta};
            output.fastq.format = "edam:format_2182";
            output_array.push(output);
          }
        }
        else if (inputs.fastq_list.length > 0) {
          throw "`use_fastq_name` or `use_bam_pu_value` should be set";
        }
        return {'output': output_array}
      }
    }
  
