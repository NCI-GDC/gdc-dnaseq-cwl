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
    var output = { "bam": inputs.bam,
                   "readgroup_meta_list": inputs.readgroup_meta_list};
    output.bam.format = "edam:format_2572";
    return {'output': output}
  }
