#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: SchemaDefRequirement
    types:
      - $import: ../../tools/readgroup.yml
  - class: StepInputExpressionRequirement

inputs:
  - id: readgroups_bam_file
    type: ../../tools/readgroup.yml#readgroups_bam_file

outputs:
  - id: pe_file_list
    type:
      type: array
      items: ../../tools/readgroup.yml#readgroup_fastq_pe_file
    outputSource: emit_readgroup_pe_contents/output
  - id: se_file_list
    type:
      type: array
      items: ../../tools/readgroup.yml#readgroup_fastq_se_file
    outputSource: emit_readgroup_se_contents/output
  - id: o1_file_list
    type:
      type: array
      items: ../../tools/readgroup.yml#readgroup_fastq_se_file
    outputSource: emit_readgroup_o1_contents/output
  - id: o2_file_list
    type:
      type: array
      items: ../../tools/readgroup.yml#readgroup_fastq_se_file
    outputSource: emit_readgroup_o2_contents/output

steps:
  - id: biobambam_bamtofastq
    run: ../../tools/biobambam2_bamtofastq.cwl
    in:
      - id: filename
        source: readgroups_bam_file
        valueFrom: $(self.bam)
    out:
      - id: output_fastq1
      - id: output_fastq2
      - id: output_fastq_o1
      - id: output_fastq_o2
      - id: output_fastq_s

  - id: bam_readgroup_to_contents
    run: ../../tools/bam_readgroup_to_contents.cwl
    in:
      - id: INPUT
        source: readgroups_bam_file
        valueFrom: $(self.bam)
      - id: MODE
        valueFrom: "lenient"
    out:
      - id: OUTPUT

  - id: emit_readgroup_pe_contents
    run: ../../tools/emit_readgroup_fastq_pe_contents.cwl
    in:
      - id: bam_readgroup_contents
        source: bam_readgroup_to_contents/OUTPUT
      - id: forward_fastq_list
        source: biobambam_bamtofastq/output_fastq1
      - id: reverse_fastq_list
        source: biobambam_bamtofastq/output_fastq2
      - id: readgroup_meta_list
        source: readgroups_bam_file
        valueFrom: $(self.readgroup_meta_list)
    out:
      - id: output

  - id: emit_readgroup_se_contents
    run: ../../tools/emit_readgroup_fastq_se_contents.cwl
    in:
      - id: bam_readgroup_contents
        source: bam_readgroup_to_contents/OUTPUT
      - id: fastq_list
        source: biobambam_bamtofastq/output_fastq_s
      - id: readgroup_meta_list
        source: readgroups_bam_file
        valueFrom: $(self.readgroup_meta_list)
    out:
      - id: output

  - id: emit_readgroup_o1_contents
    run: ../../tools/emit_readgroup_fastq_se_contents.cwl
    in:
      - id: bam_readgroup_contents
        source: bam_readgroup_to_contents/OUTPUT
      - id: fastq_list
        source: biobambam_bamtofastq/output_fastq_o1
      - id: readgroup_meta_list
        source: readgroups_bam_file
        valueFrom: $(self.readgroup_meta_list)
    out:
      - id: output

  - id: emit_readgroup_o2_contents
    run: ../../tools/emit_readgroup_fastq_se_contents.cwl
    in:
      - id: bam_readgroup_contents
        source: bam_readgroup_to_contents/OUTPUT
      - id: fastq_list
        source: biobambam_bamtofastq/output_fastq_o2
      - id: readgroup_meta_list
        source: readgroups_bam_file
        valueFrom: $(self.readgroup_meta_list)
    out:
      - id: output
