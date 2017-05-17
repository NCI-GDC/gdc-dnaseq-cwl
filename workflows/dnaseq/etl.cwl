#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
 - class: InlineJavascriptRequirement
 - class: StepInputExpressionRequirement
 - class: SubworkflowFeatureRequirement

inputs:
  - id: gdc_token
    type: File
  - id: input_bam_gdc_id
    type: string
  - id: known_snp_gdc_id
    type: string
  - id: known_snp_index_gdc_id
    type: string
  - id: reference_amb_gdc_id
    type: string
  - id: reference_ann_gdc_id
    type: string
  - id: reference_bwt_gdc_id
    type: string
  - id: reference_fa_gdc_id
    type: string
  - id: reference_fai_gdc_id
    type: string
  - id: reference_pac_gdc_id
    type: string
  - id: reference_sa_gdc_id
    type: string
  - id: start_token
    type: File
  - id: thread_count
    type: int
  - id: run_uuid
    type: string

outputs:
  - id: token
    type: File
    outputSource: generate_token/token

steps:
  - id: extract_bam
    run: ../../tools/gdc_get_object.cwl
    in:
      - id: gdc_token
        source: gdc_token
      - id: gdc_uuid
        source: input_bam_gdc_id
    out:
      - id: output

  - id: extract_known_snp
    run: ../../tools/gdc_get_object.cwl
    in:
      - id: gdc_token
        source: gdc_token
      - id: gdc_uuid
        source: known_snp_gdc_id
    out:
      - id: output

  - id: extract_known_snp_index
    run: ../../tools/gdc_get_object.cwl
    in:
      - id: gdc_token
        source: gdc_token
      - id: gdc_uuid
        source: known_snp_index_gdc_id
    out:
      - id: output

  - id: extract_ref_fa
    run: ../../tools/gdc_get_object.cwl
    in:
      - id: gdc_token
        source: gdc_token
      - id: gdc_uuid
        source: reference_fa_gdc_id
    out:
      - id: output

  - id: extract_ref_fai
    run: ../../tools/gdc_get_object.cwl
    in:
      - id: gdc_token
        source: gdc_token
      - id: gdc_uuid
        source: reference_fai_gdc_id
    out:
      - id: output

  - id: extract_ref_amb
    run: ../../tools/gdc_get_object.cwl
    in:
      - id: gdc_token
        source: gdc_token
      - id: gdc_uuid
        source: reference_amb_gdc_id
    out:
      - id: output

  - id: extract_ref_ann
    run: ../../tools/gdc_get_object.cwl
    in:
      - id: gdc_token
        source: gdc_token
      - id: gdc_uuid
        source: reference_ann_gdc_id
    out:
      - id: output

  - id: extract_ref_bwt
    run: ../../tools/gdc_get_object.cwl
    in:
      - id: gdc_token
        source: gdc_token
      - id: gdc_uuid
        source: reference_bwt_gdc_id
    out:
      - id: output

  - id: extract_ref_pac
    run: ../../tools/gdc_get_object.cwl
    in:
      - id: gdc_token
        source: gdc_token
      - id: gdc_uuid
        source: reference_pac_gdc_id
    out:
      - id: output

  - id: extract_ref_sa
    run: ../../tools/gdc_get_object.cwl
    in:
      - id: gdc_token
        source: gdc_token
      - id: gdc_uuid
        source: reference_sa_gdc_id
    out:
      - id: output

  - id: root_fasta_files
    run: ../../tools/root_fasta_dnaseq.cwl
    in:
      - id: fasta
        source: extract_ref_fa/output
      - id: fasta_amb
        source: extract_ref_amb/output
      - id: fasta_ann
        source: extract_ref_ann/output
      - id: fasta_bwt
        source: extract_ref_bwt/output
      - id: fasta_fai
        source: extract_ref_fai/output
      - id: fasta_pac
        source: extract_ref_pac/output
      - id: fasta_sa
        source: extract_ref_sa/output
    out:
      - id: output

  # - id: root_known_snp_files
  #   run: ../../tools/root_vcf.cwl
  #   in:
  #     - id: vcf
  #       source: extract_known_snp/output
  #     - id: vcf_index
  #       source: extract_known_snp_index/output
  #   out:
  #     - id: output

  - id: transform
    run: transform.cwl
    in:
      - id: input_bam
        source: extract_bam/output
      - id: known_snp
        source: extract_known_snp/output
      - id: reference_sequence
        source: root_fasta_files/output
      - id: thread_count
        source: thread_count
      - id: run_uuid
        source: run_uuid
    out:
      - id: picard_markduplicates_output
      - id: merge_all_sqlite_destination_sqlite

  # - id: load_bam
  #   run: ../../tools/gdc_put_object.cwl
  #   in:
  #     - id: input
  #       source: transform/picard_markduplicates_output
  #     - id: uuid
  #       source: uuid
  #   out:
  #     - id: output

  # - id: load_bai
  #   run: ../../tools/gdc_put_object.cwl
  #   in:
  #     - id: input
  #       source: transform/picard_markduplicates_output
  #       valueFrom: $(self.secondaryFiles[0])
  #     - id: uuid
  #       source: uuid
  #   out:
  #     - id: output

  # - id: load_sqlite
  #   run: ../../tools/gdc_put_object.cwl
  #   in:
  #     - id: input
  #       source: transform/merge_all_sqlite_destination_sqlite
  #     - id: uuid
  #       source: uuid
  #   out:
  #     - id: output

  # - id: generate_token
  #   run: ../../tools/generate_load_token.cwl
  #   in:
  #     - id: load1
  #       source: load_bam/output
  #     - id: load2
  #       source: load_bai/output
  #     - id: load3
  #       source: load_sqlite/output
  #   out:
  #     - id: token

  - id: generate_token
    run: ../../tools/generate_load_token.cwl
    in:
      - id: load1
        source: transform/merge_all_sqlite_destination_sqlite
    out:
      - id: token
