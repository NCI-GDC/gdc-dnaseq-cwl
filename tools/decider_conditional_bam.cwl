#!/usr/bin/env cwl-runner
#$namespaces:"
  #edam: "http://edamontology.org/"
cwlVersion: v1.0

requirements:
  - class: InlineJavascriptRequirement

class: ExpressionTool

inputs:
  - id: conditional_bam
    format: "edam:format_2572"
    type:
      type: array
      items: File

  - id: conditional_sqlite
    format: "edam:format_3621"
    type:
      type: array
      items: File

  - id: nonconditional_bam
    format: "edam:format_2572"
    type: File

  - id: nonconditional_sqlite
    format: "edam:format_2572"
    type: File

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
      if (inputs.conditional_bam.length > 1) {
        throw "conditional_bam length should only be 0 or 1"
      }
      else if (inputs.conditional_bam.length == 1) {
        var output = inputs.conditional_bam[0];
        var sqlite = inputs.conditional_sqlite[0];
      }
      else if (inputs.conditional_bam.length == 0) {
        var output = inputs.nonconditional_bam;
        var sqlite = inputs.nonconditional_sqlite;
      }

      return {'output': output, 'sqlite': sqlite}
    }
