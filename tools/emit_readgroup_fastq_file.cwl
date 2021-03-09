cwlVersion: v1.0
class: ExpressionTool
id: emit_readgroup_fastq_file
requirements:
  - class: SchemaDefRequirement
    types:
      - $import: readgroup.yml
  - class: InlineJavascriptRequirement

inputs:
  forward_fastq:
    type: File

  reverse_fastq:
    type: File?

  readgroup_meta:
    type: readgroup.yml#readgroup_meta

outputs:
  output:
    type: readgroup.yml#readgroup_fastq_file

expression: |
  ${
    if( inputs.reverse_fastq ) {
        var output = { "forward_fastq": inputs.forward_fastq,
                       "reverse_fastq": inputs.reverse_fastq,
                       "readgroup_meta": inputs.readgroup_meta
                       };
        output.forward_fastq.format = "edam:format_2182";
        output.reverse_fastq.format = "edam:format_2182";
    }
    else {
        var output = { "forward_fastq": inputs.forward_fastq,
                       "readgroup_meta": inputs.readgroup_meta
                       };
        output.forward_fastq.format = "edam:format_2182";
    }
    return {'output': output}
  }
