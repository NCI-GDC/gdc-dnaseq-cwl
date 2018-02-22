#!/usr/bin/env cwl-runner

cwlVersion: v1.0

requirements:
  - $import: readgroup.yml
  - class: InlineJavascriptRequirement

class: ExpressionTool

inputs:
  - id: capture_kit_bait_file
    type:
      type: array
      items: File

  - id: capture_kit_target_file
    type:
      type: array
      items: File

  - id: forward_fastq
    type: File

  - id: reverse_fastq
    type: File

  - id: readgroup_meta
    type: readgroup.yml#readgroup_meta

outputs:
  - id: output
    type: readgroup.yml#readgroup_fastq_pe_file

expression: |
  ${
    const output = { "forward_fastq": inputs.forward_fastq,
                     "reverse_fastq": inputs.reverse_fastq,
                     "readgroup_meta": inputs.readgroup_meta,
                     "capture_kit_bait_file": [],
                     "capture_kit_target_file": []
                    };
    for (var i = 0; i < inputs.capture_kit_bait_file.length; i++) {
      output["capture_kit_bait_file"].push(inputs.capture_kit_bait_file[i]);
    }
    for (var i = 0; i < inputs.capture_kit_target_file.length; i++) {
      output["capture_kit_target_file"].push(inputs.capture_kit_target_file[i]);
    }
    return {'output': output}
  }
