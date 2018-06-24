#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: InlineJavascriptRequirement

class: ExpressionTool

inputs:
  - id: conditional_bam1
    format: "edam:format_2572"
    type:
      type: array
      items: File

  - id: conditional_sqlite1
    format: "edam:format_3621"
    type:
      type: array
      items: File

  - id: conditional_bam2
    format: "edam:format_2572"
    type:
      type: array
      items: File

  - id: conditional_sqlite2
    format: "edam:format_3621"
    type:
      type: array
      items: File

outputs:
  - id: output
    format: "edam:format_2572"
    type: File
    secondaryFiles:
      - ^.bai

  - id: sqlite
    format: "edam:format_3621"
    type: File

expression: |
   ${
      if (inputs.conditional_bam1.length == 1 && inputs.conditional_bam2.length == 0)  {
        var output = inputs.conditional_bam1[0];
        var sqlite = inputs.conditional_sqlite1[0];
      }
      else if (inputs.conditional_bam1.length == 0 && inputs.conditional_bam2.length == 1) {
        var output = inputs.conditional_bam2[0];
        var sqlite = inputs.conditional_sqlite2[0];
      }
      else {
        throw "unhandled";
      }

      return {'output': output, 'sqlite': sqlite};
    }
