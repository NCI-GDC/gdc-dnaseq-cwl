cwlVersion: v1.0
class: Workflow
id: gdc_dnaseq_fastq_clean_wf
requirements:
  - class: InlineJavascriptRequirement
  - class: ScatterFeatureRequirement
  - class: StepInputExpressionRequirement
  - class: SchemaDefRequirement
    types:
      - $import: ../../tools/readgroup.yml

inputs:
  input:
    type: ../../tools/readgroup.yml#readgroup_fastq_file
  job_uuid: string

outputs:
  output:
    type: ../../tools/readgroup.yml#readgroup_fastq_file
    outputSource: emit_readgroup_fastq_file/output
  sqlite:
    type: File
    outputSource: json_to_sqlite/sqlite

steps:
  fastq_cleaner:
    run: ../../tools/fastq_cleaner.cwl
    in:
      fastq1:
        source: input
        valueFrom: $(self.forward_fastq)
      fastq2:
        source: input
        valueFrom: $(self.reverse_fastq)
    out: [ cleaned_fastq1, cleaned_fastq2, result_json ]

  emit_readgroup_fastq_file:
    run: ../../tools/emit_readgroup_fastq_file.cwl
    in:
      forward_fastq: fastq_cleaner/cleaned_fastq1
      reverse_fastq: fastq_cleaner/cleaned_fastq2
      readgroup_meta:
        source: input
        valueFrom: $(self.readgroup_meta)
    out: [ output ]

  json_to_sqlite:
    run: ../../tools/json_to_sqlite.cwl
    in:
      input_json: fastq_cleaner/result_json
      job_uuid: job_uuid
      table_name:
        source: input
        valueFrom: |
          ${
             var res = self.reverse_fastq === null ? "fastq_cleaner_se" : "fastq_cleaner_pe";
             return(res);
           }
    out: [ sqlite, log ]
