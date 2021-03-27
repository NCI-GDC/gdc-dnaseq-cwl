cwlVersion: v1.0
class: ExpressionTool
id: rename_fastq_records
requirements:
  - class: InlineJavascriptRequirement
  - class: SchemaDefRequirement
    types:
      - $import: readgroup.yml

inputs:
  input:
    type:
      type: array
      items: readgroup.yml#readgroup_fastq_file

outputs:
  output:
    type:
      type: array
      items: readgroup.yml#readgroup_fastq_file

expression: |
  ${
        function rename(root, index, suffix) {
            var n = root.toString() + "_" + index.toString() + suffix
            return n
        }
        var output = [];
        var suffixes = [
            "_1.fq.gz",
            "_2.fq.gz",
            "_o1.fq.gz",
            "_o2.fq.gz",
            "_s.fq.gz"
        ]
        for (var i = 0; i < inputs.input.length; i++) {
            var readgroup_array = inputs.input[i];
            for (var j = 0; j < readgroup_array.length; j++) {
                var readgroup = readgroup_array[j];
                var foward_fq = readgroup["forward_fastq"]["basename"]
                for (var k = 0; k < suffixes.length; k++) {
                    if (foward_fq.endsWith(suffixes[k])) {
                        readgroup["forward_fastq"]["basename"] = rename(i, j, suffixes[k]);
                    }
                }
                if (readgroup["reverse_fastq"]){
                    var reverse_fq = readgroup["reverse_fastq"]["basename"]
                    for (var k = 0; k < suffixes.length; k++) {
                        if (reverse_fq.endsWith(suffixes[k])) {
                            readgroup["reverse_fastq"]["basename"] = rename(i, j, suffixes[k]);
                        }
                    }
                }
                output.push(readgroup);
            }
        }
        return {'output': output}
    }

