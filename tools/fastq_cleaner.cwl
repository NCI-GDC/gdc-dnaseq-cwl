cwlVersion: v1.0
class: CommandLineTool
id: fastq_cleaner
requirements:
  - class: DockerRequirement
    dockerPull: "{{ docker_repo }}/fastq_cleaner:{{ fastq_cleaner }}"
  - class: InlineJavascriptRequirement
    expressionLib:
      $import: ./expression_lib.cwl
  - class: ResourceRequirement
    coresMin: 2
    coresMax: 2
    ramMin: 2000
    ramMax: 2000
    tmpdirMin: $(Math.ceil(1.1 * fastq_files_size(inputs.fastq1, inputs.fastq2)))
    tmpdirMax: $(Math.ceil(1.1 * fastq_files_size(inputs.fastq1, inputs.fastq2)))
    outdirMin: $(Math.ceil(1.1 * fastq_files_size(inputs.fastq1, inputs.fastq2)))
    outdirMax: $(Math.ceil(1.1 * fastq_files_size(inputs.fastq1, inputs.fastq2)))

inputs:
  fastq1:
    type: File
    inputBinding:
      prefix: --fastq

  fastq2:
    type: File?
    inputBinding:
      prefix: --fastq2

  reads_in_memory:
    type: long
    default: 500000
    inputBinding:
      prefix: --reads_in_memory

outputs:
  cleaned_fastq1:
    type: File
    outputBinding:
      glob: $(inputs.fastq1.basename)

  cleaned_fastq2:
    type: File?
    outputBinding:
      glob: |
       ${
          var res = inputs.fastq2 === null ? null : inputs.fastq2.basename;
          return res;
        }

  result_json:
    type: File
    outputBinding:
      glob: "result.json"

baseCommand: [/usr/local/bin/fastq_cleaner]
