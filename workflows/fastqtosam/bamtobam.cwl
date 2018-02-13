#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - $import: ../../tools/readgroup_no_pu.yaml
  - class: StepInputExpressionRequirement

inputs:
  - id: bioclient_config
    type: File
  - id: bam_record_uuid
    type: ../../tools/readgroup_no_pu.yaml#bam_record_uuid

outputs:
  - id: output_bam
    type: File
    outputSource: picard_revertsam/OUTPUT_BAM

steps:
  - id: extract_bam
    run: ../../tools/bio_client_download.cwl
    in:
      - id: config-file
        source: bioclient_config
      - id: download_handle
        source: bam_record_uuid
        valueFrom: $(self.bam_uuid)
      - id: file_size
        source: bam_record_uuid
        valueFrom: $(self.bam_file_size)
    out:
      - id: output

  - id: bam_readgroup_to_json
    run: ../../tools/bam_readgroup_to_json.cwl
    in:
      - id: INPUT
        source: extract_bam/output
      - id: MODE
        valueFrom: "lenient"
    out:
      - id: OUTPUT

  # - id: validate_readgroup_meta
  #   run: ../../tools/validate_readgroup_meta.cwl
  #   in:
  #     - id: readgroup_meta
  #       source: readgroup_record_uuid
  #       valueFrom: $(self.readgroup_meta)
  #     - id: bam_json
  #       source: bam_readgroup_to_json
  #   out:
  #     - id: result

  # - id: picard_validatesamfile_original
  #   run: ../../tools/picard_validatesamfile.cwl
  #   in:
  #     - id: INPUT
  #       source: extract_bam/output
  #     - id: VALIDATION_STRINGENCY
  #       valueFrom: "LENIENT"
  #   out:
  #     - id: OUTPUT

  # # need eof and dup QNAME detection
  # - id: picard_validatesamfile_original_to_sqlite
  #   run: ../../tools/picard_validatesamfile_to_sqlite.cwl
  #   in:
  #     - id: bam
  #       source: input_bam
  #       valueFrom: $(self.basename)
  #     - id: input_state
  #       valueFrom: "original"
  #     - id: metric_path
  #       source: picard_validatesamfile_original/OUTPUT
  #     - id: job_uuid
  #       source: job_uuid
  #   out:
  #     - id: sqlite


  - id: picard_revertsam
    run: ../../tools/picard_revertsam.cwl
    in:
      - id: INPUT
        source: extract_bam/output
      - id: OUTPUT
        source: extract_bam/output
        valueFrom: $(self.basename)
    out:
      - id: OUTPUT_BAM
