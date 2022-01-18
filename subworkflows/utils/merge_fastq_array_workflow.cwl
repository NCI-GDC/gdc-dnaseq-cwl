cwlVersion: v1.0
class: Workflow
id: gdc_dnaseq_merge_fastq_array_wf
requirements:
  - class: InlineJavascriptRequirement
  - class: MultipleInputFeatureRequirement
  - class: SchemaDefRequirement
    types:
      - $import: ../../tools/readgroup.yml
  - class: StepInputExpressionRequirement

inputs:
  bam_pe_fastqs:
    type:
      type: array
      items:
        type: array
        items: ../../tools/readgroup.yml#readgroup_fastq_file

  bam_se_fastqs:
    type:
      type: array
      items:
        type: array
        items: ../../tools/readgroup.yml#readgroup_fastq_file

  bam_o1_fastqs:
    type:
      type: array
      items:
        type: array
        items: ../../tools/readgroup.yml#readgroup_fastq_file

  bam_o2_fastqs:
    type:
      type: array
      items:
        type: array
        items: ../../tools/readgroup.yml#readgroup_fastq_file

  fastqs_pe:
    type:
      type: array
      items: ../../tools/readgroup.yml#readgroup_fastq_file

  fastqs_se:
    type:
      type: array
      items: ../../tools/readgroup.yml#readgroup_fastq_file

outputs:
  merged_pe_fastq_array:
    type:
      type: array
      items: ../../tools/readgroup.yml#readgroup_fastq_file
    outputSource: merge_pe_fastq_records/output

  merged_se_fastq_array:
    type:
      type: array
      items: ../../tools/readgroup.yml#readgroup_fastq_file
    outputSource: merge_all_se_fastq_records/output

steps:
  merge_bam_pe_fastq_records:
    run: ../../tools/merge_fastq_records.cwl
    in:
      input: bam_pe_fastqs
    out: [ output ]

  rename_bam_pe_fastq_records:
    run: ../../tools/rename_fastq_records.cwl
    in:
      input: merge_bam_pe_fastq_records/output
      tag:
        valueFrom: "gdc_bam_pe"
    out: [ output ]

  merge_pe_fastq_records:
    run: ../../tools/merge_fastq_records.cwl
    in:
      input:
        source: [
          rename_bam_pe_fastq_records/output,
          fastqs_pe
        ]
    out: [ output ]

  merge_bam_se_fastq_records:
    run: ../../tools/merge_fastq_records.cwl
    in:
      input: bam_se_fastqs
    out: [ output ]

  rename_bam_se_fastq_records:
    run: ../../tools/rename_fastq_records.cwl
    in:
      input: merge_bam_se_fastq_records/output
      tag:
        valueFrom: "gdc_bam_se"
    out: [ output ]

  merge_bam_o1_fastq_records:
    run: ../../tools/merge_fastq_records.cwl
    in:
      input: bam_o1_fastqs
    out: [ output ]

  rename_bam_o1_fastq_records:
    run: ../../tools/rename_fastq_records.cwl
    in:
      input: merge_bam_o1_fastq_records/output
      tag:
        valueFrom: "gdc_bam_o1"
    out: [ output ]

  merge_bam_o2_fastq_records:
    run: ../../tools/merge_fastq_records.cwl
    in:
      input: bam_o2_fastqs
    out: [ output ]

  rename_bam_o2_fastq_records:
    run: ../../tools/rename_fastq_records.cwl
    in:
      input: merge_bam_o2_fastq_records/output
      tag:
        valueFrom: "gdc_bam_o2"
    out: [ output ]

  merge_all_se_fastq_records:
    run: ../../tools/merge_fastq_records.cwl
    in:
      input:
        source: [
          rename_bam_se_fastq_records/output,
          rename_bam_o1_fastq_records/output,
          rename_bam_o2_fastq_records/output,
          fastqs_se
        ]
    out: [ output ]

