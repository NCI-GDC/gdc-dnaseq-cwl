#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: ScatterFeatureRequirement
  - class: SchemaDefRequirement
    types:
      - $import: ../../tools/readgroup.yml
  - class: StepInputExpressionRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  - id: readgroups_bam_file
    type: ../../tools/readgroup.yml#readgroups_bam_file

outputs:
  - id: pe_file_list
    type:
      type: array
      items: ../../tools/readgroup.yml#readgroup_fastq_pe_file
    outputSource: readgroup_fastq_pe/output
  - id: se_file_list
    type:
      type: array
      items: ../../tools/readgroup.yml#readgroup_fastq_se_file
    outputSource: readgroup_fastq_se/output
  - id: o1_file_list
    type:
      type: array
      items: ../../tools/readgroup.yml#readgroup_fastq_se_file
    outputSource: readgroup_fastq_o1/output
  - id: o2_file_list
    type:
      type: array
      items: ../../tools/readgroup.yml#readgroup_fastq_se_file
    outputSource: readgroup_fastq_o2/output

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

  - id: bam_readgroup_to_json
    run: ../../tools/bam_readgroup_to_json.cwl
    in:
      - id: INPUT
        source: readgroups_bam_file
        valueFrom: $(self.bam)
      - id: MODE
        valueFrom: "lenient"
    out:
      - id: OUTPUT

  - id: decider_readgroup_pe
    run: ../../tools/decider_readgroup_expression.cwl
    in:
      - id: fastq
        source: biobambam_bamtofastq/output_fastq1
      - id: readgroup_json
        source: bam_readgroup_to_json/OUTPUT
    out:
      - id: output

  - id: decider_readgroup_se
    run: ../../tools/decider_readgroup_expression.cwl
    in:
      - id: fastq
        source: biobambam_bamtofastq/output_fastq_s
      - id: readgroup_json
        source: bam_readgroup_to_json/OUTPUT
    out:
      - id: output

  - id: decider_readgroup_o1
    run: ../../tools/decider_readgroup_expression.cwl
    in:
      - id: fastq
        source: biobambam_bamtofastq/output_fastq_o1
      - id: readgroup_json
        source: bam_readgroup_to_json/OUTPUT
    out:
      - id: output

  - id: decider_readgroup_o2
    run: ../../tools/decider_readgroup_expression.cwl
    in:
      - id: fastq
        source: biobambam_bamtofastq/output_fastq_o2
      - id: readgroup_json
        source: bam_readgroup_to_json/OUTPUT
    out:
      - id: output

  - id: readgroup_fastq_pe
    run: readgroup_fastq_pe.cwl
    scatter: [forward_fastq, reverse_fastq, readgroup_json]
    scatterMethod: "dotproduct"
    in:
      - id: forward_fastq
        source: biobambam_bamtofastq/output_fastq1
      - id: reverse_fastq
        source: biobambam_bamtofastq/output_fastq2
      - id: readgroup_json
        source: decider_readgroup_pe/output
      - id: readgroup_meta_list
        source: readgroups_bam_file
        valueFrom: $(self.readgroup_meta_list)
    out:
      - id: output

  - id: readgroup_fastq_se
    run: readgroup_fastq_se.cwl
    scatter: [fastq, readgroup_json]
    scatterMethod: "dotproduct"
    in:
      - id: fastq
        source: biobambam_bamtofastq/output_fastq_s
      - id: readgroup_json
        source: decider_readgroup_se/output
      - id: readgroup_meta_list
        source: readgroups_bam_file
        valueFrom: $(self.readgroup_meta_list)
    out:
      - id: output

  - id: readgroup_fastq_o1
    run: readgroup_fastq_se.cwl
    scatter: [fastq, readgroup_json]
    scatterMethod: "dotproduct"    
    in:
      - id: fastq
        source: biobambam_bamtofastq/output_fastq_o1
      - id: readgroup_json
        source: decider_readgroup_o1/output
      - id: readgroup_meta_list
        source: readgroups_bam_file
        valueFrom: $(self.readgroup_meta_list)
    out:
      - id: output

  - id: readgroup_fastq_o2
    run: readgroup_fastq_se.cwl
    scatter: [fastq, readgroup_json]
    scatterMethod: "dotproduct"    
    in:
      - id: fastq
        source: biobambam_bamtofastq/output_fastq_o2
      - id: readgroup_json
        source: decider_readgroup_o2/output
      - id: readgroup_meta_list
        source: readgroups_bam_file
        valueFrom: $(self.readgroup_meta_list)
    out:
      - id: output

