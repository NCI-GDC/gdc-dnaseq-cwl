#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - $import: ../../tools/readgroup_path.yaml
  - class: StepInputExpressionRequirement

inputs:
  - id: readgroups_bam
    type: ../../tools/readgroup_path.yaml#readgroups_bam

outputs:
  - id: output_bam
    type: File
    outputSource: picard_revertsam/OUTPUT_BAM

steps:
  - id: bam_readgroup_to_json
    run: ../../tools/bam_readgroup_to_json.cwl
    in:
      - id: INPUT
        source: readgroups_bam
      - id: MODE
        valueFrom: "lenient"
    out:
      - id: OUTPUT

  - id: validate_readgroup_meta
    run: ../../tools/validate_readgroup_meta.cwl
    scatter: [bam_readgroup_json]
    in:
      - id: readgroup_meta_list
        source: readgroups_bam
        valueFrom: $(self.readgroup_meta_list)
      - id: bam_readgroup_json
        source: bam_readgroup_to_json/OUTPUT
    out:
      - id: result

  - id: picard_revertsam
    run: ../../tools/picard_revertsam.cwl
    in:
      - id: INPUT
        source: readgroups_bam
        valueFrom: $(self.bam)
      - id: OUTPUT
        source: extract_bam
        valueFrom: $(self.basename)
    out:
      - id: OUTPUT_BAM
