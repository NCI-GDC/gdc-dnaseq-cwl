#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - class: InlineJavascriptRequirement
  - class: SchemaDefRequirement
    types:
      - $import: readgroup.yml

class: ExpressionTool

inputs:
  - id: bam
    type: File

  - id: readgroup_meta_list
    type:
      type: array
      items: readgroup.yml#readgroup_meta

outputs:
  - id: output
    type: readgroup.yml#readgroups_bam_file

expression: |
  ${
    var formatted_bam = inputs.bam;
    formatted_bam.format = "edam:format_2572";
    var output = { "bam": formatted_bam,
                   "readgroup_meta_list": inputs.readgroup_meta_list};

    return {'output': output}
  }
