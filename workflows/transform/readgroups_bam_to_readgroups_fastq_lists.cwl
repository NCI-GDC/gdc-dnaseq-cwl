#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: SchemaDefRequirement
    types:
      - $import: ../../tools/readgroup.yml
  - class: StepInputExpressionRequirement

inputs:
  readgroups_bam_file:
    type: ../../tools/readgroup.yml#readgroups_bam_file

outputs:
  pe_file_list:
    type:
      type: array
      items: ../../tools/readgroup.yml#readgroup_fastq_pe_file
    outputSource: emit_readgroup_pe_contents/output
  se_file_list:
    type:
      type: array
      items: ../../tools/readgroup.yml#readgroup_fastq_se_file
    outputSource: emit_readgroup_se_contents/output
  o1_file_list:
    type:
      type: array
      items: ../../tools/readgroup.yml#readgroup_fastq_se_file
    outputSource: emit_readgroup_o1_contents/output
  o2_file_list:
    type:
      type: array
      items: ../../tools/readgroup.yml#readgroup_fastq_se_file
    outputSource: emit_readgroup_o2_contents/output

steps:
  biobambam_bamtofastq:
    run: ../../tools/biobambam2_bamtofastq.cwl
    in:
      filename:
        source: readgroups_bam_file
        valueFrom: $(self.bam)
    out: [ output_fastq1, output_fastq2, output_fastq_o1, output_fastq_o2, output_fastq_s ]

  bam_readgroup_to_contents:
    run: ../../tools/bam_readgroup_to_contents.cwl
    in:
      INPUT:
        source: readgroups_bam_file
        valueFrom: $(self.bam)
      MODE:
        valueFrom: "lenient"
    out: [ OUTPUT ]

  emit_readgroup_pe_contents:
    run: ../../tools/emit_readgroup_fastq_pe_contents.cwl
    in:
      bam_readgroup_contents: bam_readgroup_to_contents/OUTPUT
      forward_fastq_list: biobambam_bamtofastq/output_fastq1
      reverse_fastq_list: biobambam_bamtofastq/output_fastq2
      readgroup_meta_list:
        source: readgroups_bam_file
        valueFrom: $(self.readgroup_meta_list)
    out: [ output ]

  emit_readgroup_se_contents:
    run: ../../tools/emit_readgroup_fastq_se_contents.cwl
    in:
      bam_readgroup_contents: bam_readgroup_to_contents/OUTPUT
      fastq_list: biobambam_bamtofastq/output_fastq_s
      readgroup_meta_list:
        source: readgroups_bam_file
        valueFrom: $(self.readgroup_meta_list)
    out: [ output ]

  emit_readgroup_o1_contents:
    run: ../../tools/emit_readgroup_fastq_se_contents.cwl
    in:
      bam_readgroup_contents: bam_readgroup_to_contents/OUTPUT
      fastq_list: biobambam_bamtofastq/output_fastq_o1
      readgroup_meta_list:
        source: readgroups_bam_file
        valueFrom: $(self.readgroup_meta_list)
    out: [ output ]

  emit_readgroup_o2_contents:
    run: ../../tools/emit_readgroup_fastq_se_contents.cwl
    in:
      bam_readgroup_contents: bam_readgroup_to_contents/OUTPUT
      fastq_list: biobambam_bamtofastq/output_fastq_o2
      readgroup_meta_list:
        source: readgroups_bam_file
        valueFrom: $(self.readgroup_meta_list)
    out: [ output ]
