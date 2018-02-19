#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - $import: readgroup.yml
  - class: InlineJavascriptRequirement

class: ExpressionTool

inputs:
  - id: fastq1
    type: File

  - id: fastq2
    type: File

  - id: readgroup_json
    type: File
    inputBinding:
      loadContents: true
      valueFrom: $(null)

outputs:
  - id: output
    type: readgroup.yml#readgroup_fastq_se_file

expression: |
  ${
    const readgroup = JSON.parse(inputs.input.contents);
    var readgroup_meta = new Object();
    for (var i in readgroup) {
      readgroup_meta[i] = readgroup[i];
    }

    const forward_fastq = inputs.fastq1;
    const reverse_fastq = inputs.fastq2;

    const output = {'forward_fastq': forward_fastq,
                  'reverse_fastq': reverse_fastq,
                  'readgroup_meta': readgroup_meta
                  }

    return {'output': output};
  }
