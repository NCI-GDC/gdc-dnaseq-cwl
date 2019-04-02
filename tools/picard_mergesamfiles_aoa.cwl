#!/usr/bin/env cwl-runner
#$namespaces:"
  #edam: "http://edamontology.org/"
cwlVersion: v1.0

requirements:
  - class: DockerRequirement
    dockerPull: quay.io/ncigdc/picard:092d034713aff237cf07ef28c22a46a113d1a59dc7ec6d71beb72295044a46f8
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 1
    ramMin: 10000
    ramMax: 10000
    tmpdirMin: |
      ${
      var req_space = 0;
      for (var i = 0; i < inputs.INPUT.length; i++) {
        for (var j = 0; j < inputs.INPUT[i].length; j++) {
          req_space += inputs.INPUT[i][j].size;
        }
      }
      return Math.ceil(2 * req_space / 1048576);
      }      
    tmpdirMax: |
      ${
      var req_space = 0;
      for (var i = 0; i < inputs.INPUT.length; i++) {
        for (var j = 0; j < inputs.INPUT[i].length; j++) {
          req_space += inputs.INPUT[i][j].size;
        }
      }
      return Math.ceil(2 * req_space / 1048576);
      }      
    outdirMin: |
      ${
      var req_space = 0;
      for (var i = 0; i < inputs.INPUT.length; i++) {
        for (var j = 0; j < inputs.INPUT[i].length; j++) {
          req_space += inputs.INPUT[i][j].size;
        }
      }
      return Math.ceil(2 * req_space / 1048576);
      }      
    outdirMax: |
      ${
      var req_space = 0;
      for (var i = 0; i < inputs.INPUT.length; i++) {
        for (var j = 0; j < inputs.INPUT[i].length; j++) {
          req_space += inputs.INPUT[i][j].size;
        }
      }
      return Math.ceil(2 * req_space / 1048576);
      }      

class: CommandLineTool

inputs:
  - id: ASSUME_SORTED
    type: boolean
    default: false
    inputBinding:
      prefix: ASSUME_SORTED=
      separate: false

  - id: CREATE_INDEX
    type: string
    default: "true"
    inputBinding:
      prefix: CREATE_INDEX=
      separate: false

  - id: INPUT
    format: "edam:format_2572"
    type:
      type: array
      items:
        type: array
        items: File

  - id: INTERVALS
    type: ["null", File]
    inputBinding:
      prefix: INTERVALS=
      separate: false

  - id: MERGE_SEQUENCE_DICTIONARIES
    type: string
    default: "false"
    inputBinding:
      prefix: MERGE_SEQUENCE_DICTIONARIES=
      separate: false

  - id: OUTPUT
    type: string
    inputBinding:
      prefix: OUTPUT=
      separate: false

  - id: SORT_ORDER
    type: string
    default: coordinate
    inputBinding:
      prefix: SORT_ORDER=
      separate: false

  - id: TMP_DIR
    type: string
    default: .
    inputBinding:
      prefix: TMP_DIR=
      separate: false

  - id: USE_THREADING
    type: string
    default: "true"
    inputBinding:
      prefix: USE_THREADING=
      separate: false

  - id: VALIDATION_STRINGENCY
    type: string
    default: STRICT
    inputBinding:
      prefix: VALIDATION_STRINGENCY=
      separate: false

outputs:
  - id: MERGED_OUTPUT
    format: "edam:format_2572"
    type: File
    outputBinding:
      glob: $(inputs.OUTPUT)

arguments:
  - valueFrom: |
      ${
        var cmd = ["java", "-jar", "/usr/local/bin/picard.jar", "MergeSamFiles"];
        var input_array = [];
        for (var i = 0; i < inputs.INPUT.length; i++) {
          for (var j = 0; j < inputs.INPUT[i].length; j++) {
            var filesize = inputs.INPUT[i][j].size;
            if (filesize > 0) {
              input_array.push("INPUT=" + inputs.INPUT[i][j].path);
            }
          }
        }

        if (input_array.length == 0) {
          var cmd = ['/usr/bin/touch', inputs.OUTPUT];
          return cmd;
        }
        else {
          var run_cmd = cmd.concat(input_array);
          return run_cmd;
        }
      }

baseCommand: []
