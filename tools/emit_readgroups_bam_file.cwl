cwlVersion: v1.0
class: ExpressionTool
id: emit_readgroups_bam_file
requirements:
  - class: InlineJavascriptRequirement
  - class: SchemaDefRequirement
    types:
      - $import: readgroup.yml

inputs:
  bam: File

  readgroup_meta_list:
    type:
      type: array
      items: readgroup.yml#readgroup_meta

outputs:
  output:
    type: readgroup.yml#readgroups_bam_file

expression: |
  ${
    var output = { "bam": inputs.bam,
                   "readgroup_meta_list": inputs.readgroup_meta_list};
    output.bam.format = "edam:format_2572";
    return {'output': output}
  }
