#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
 - class: InlineJavascriptRequirement
 - class: StepInputExpressionRequirement
 - class: SubworkflowFeatureRequirement

inputs:
  - id: aws_config
    type: File
  - id: aws_shared_credentials
    type: File
  - id: bam_signpost_id
    type: string
  - id: db_cred_path
    type: File
  - id: db_snp_signpost_id
    type: string
  - id: endpoint_json
    type: File
  - id: load_bucket
    type: string
  - id: load_s3cfg_section
    type: string
  - id: reference_amb_signpost_id
    type: string
  - id: reference_ann_signpost_id
    type: string
  - id: reference_bwt_signpost_id
    type: string
  - id: reference_fa_signpost_id
    type: string
  - id: reference_fai_signpost_id
    type: string
  - id: reference_pac_signpost_id
    type: string
  - id: reference_sa_signpost_id
    type: string
  - id: signpost_base_url
    type: string
  - id: thread_count
    type: int
  - id: uuid
    type: string

outputs:
  - id: token
    type: File
    outputSource: generate_token/token
  - id: harmonized_bam_url
    type: string
    outputSource: transform/picard_markduplicates_output
    valueFrom: $(inputs.load_bucket + '/' + self.basename)

steps:
  - id: extract_bam_signpost
    run: ../../tools/get_signpost_json.cwl
    in:
      - id: signpost_id
        source: bam_signpost_id
      - id: base_url
        source: signpost_base_url
    out:
      - id: output

  - id: extract_bam
    run: ../../tools/aws_s3_get_signpost.cwl
    in:
      - id: aws_config
        source: aws_config
      - id: aws_shared_credentials
        source: aws_shared_credentials
      - id: signpost_json
        source: extract_bam_signpost/output
      - id: endpoint_json
        source: endpoint_json
    out:
      - id: output

  - id: extract_db_snp_signpost
    run: ../../tools/get_signpost_json.cwl
    in:
      - id: signpost_id
        source: db_snp_signpost_id
      - id: base_url
        source: signpost_base_url
    out:
      - id: output

  - id: extract_db_snp
    run: ../../tools/aws_s3_get_signpost.cwl
    in:
      - id: aws_config
        source: aws_config
      - id: aws_shared_credentials
        source: aws_shared_credentials
      - id: signpost_json
        source: extract_db_snp_signpost/output
      - id: endpoint_json
        source: endpoint_json
    out:
      - id: output

  - id: extract_ref_fa_signpost
    run: ../../tools/get_signpost_json.cwl
    in:
      - id: signpost_id
        source: reference_fa_signpost_id
      - id: base_url
        source: signpost_base_url
    out:
      - id: output

  - id: extract_ref_fa
    run: ../../tools/aws_s3_get_signpost.cwl
    in:
      - id: aws_config
        source: aws_config
      - id: aws_shared_credentials
        source: aws_shared_credentials
      - id: signpost_json
        source: extract_ref_fa_signpost/output
      - id: endpoint_json
        source: endpoint_json
    out:
      - id: output

  - id: extract_ref_fai_signpost
    run: ../../tools/get_signpost_json.cwl
    in:
      - id: signpost_id
        source: reference_fai_signpost_id
      - id: base_url
        source: signpost_base_url
    out:
      - id: output

  - id: extract_ref_fai
    run: ../../tools/aws_s3_get_signpost.cwl
    in:
      - id: aws_config
        source: aws_config
      - id: aws_shared_credentials
        source: aws_shared_credentials
      - id: signpost_json
        source: extract_ref_fai_signpost/output
      - id: endpoint_json
        source: endpoint_json
    out:
      - id: output

  - id: extract_ref_amb_signpost
    run: ../../tools/get_signpost_json.cwl
    in:
      - id: signpost_id
        source: reference_amb_signpost_id
      - id: base_url
        source: signpost_base_url
    out:
      - id: output

  - id: extract_ref_amb
    run: ../../tools/aws_s3_get_signpost.cwl
    in:
      - id: aws_config
        source: aws_config
      - id: aws_shared_credentials
        source: aws_shared_credentials
      - id: signpost_json
        source: extract_ref_amb_signpost/output
      - id: endpoint_json
        source: endpoint_json
    out:
      - id: output

  - id: extract_ref_ann_signpost
    run: ../../tools/get_signpost_json.cwl
    in:
      - id: signpost_id
        source: reference_ann_signpost_id
      - id: base_url
        source: signpost_base_url
    out:
      - id: output

  - id: extract_ref_ann
    run: ../../tools/aws_s3_get_signpost.cwl
    in:
      - id: aws_config
        source: aws_config
      - id: aws_shared_credentials
        source: aws_shared_credentials
      - id: signpost_json
        source: extract_ref_ann_signpost/output
      - id: endpoint_json
        source: endpoint_json
    out:
      - id: output

  - id: extract_ref_bwt_signpost
    run: ../../tools/get_signpost_json.cwl
    in:
      - id: signpost_id
        source: reference_bwt_signpost_id
      - id: base_url
        source: signpost_base_url
    out:
      - id: output

  - id: extract_ref_bwt
    run: ../../tools/aws_s3_get_signpost.cwl
    in:
      - id: aws_config
        source: aws_config
      - id: aws_shared_credentials
        source: aws_shared_credentials
      - id: signpost_json
        source: extract_ref_bwt_signpost/output
      - id: endpoint_json
        source: endpoint_json
    out:
      - id: output

  - id: extract_ref_pac_signpost
    run: ../../tools/get_signpost_json.cwl
    in:
      - id: signpost_id
        source: reference_pac_signpost_id
      - id: base_url
        source: signpost_base_url
    out:
      - id: output

  - id: extract_ref_pac
    run: ../../tools/aws_s3_get_signpost.cwl
    in:
      - id: aws_config
        source: aws_config
      - id: aws_shared_credentials
        source: aws_shared_credentials
      - id: signpost_json
        source: extract_ref_pac_signpost/output
      - id: endpoint_json
        source: endpoint_json
    out:
      - id: output

  - id: extract_ref_sa_signpost
    run: ../../tools/get_signpost_json.cwl
    in:
      - id: signpost_id
        source: reference_sa_signpost_id
      - id: base_url
        source: signpost_base_url
    out:
      - id: output

  - id: extract_ref_sa
    run: ../../tools/aws_s3_get_signpost.cwl
    in:
      - id: aws_config
        source: aws_config
      - id: aws_shared_credentials
        source: aws_shared_credentials
      - id: signpost_json
        source: extract_ref_sa_signpost/output
      - id: endpoint_json
        source: endpoint_json
    out:
      - id: output

  - id: root_fasta_files
    run: ../../tools/copy_files_to_dir.cwl
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

  - id: transform
    run: transform.cwl
    in:
      - id: bam_path
        source: extract_bam/output
      - id: db_snp_path
        source: extract_db_snp/output
      - id: reference_fasta_path
        source: root_fasta_files/output_fasta
      - id: thread_count
        source: thread_count
      - id: uuid
        source: uuid
    out:
      - id: picard_markduplicates_output
      - id: merge_all_sqlite_destination_sqlite

  - id: load_bam
    run: ../../tools/aws_s3_put.cwl
    in:
      - id: aws_config
        source: aws_config
      - id: aws_shared_credentials
        source: aws_shared_credentials
      - id: endpoint_json
        source: endpoint_json
      - id: input
        source: dnaseq_workflow/picard_markduplicates_output_bam
      - id: s3cfg_section
        source: load_s3cfg_section
      - id: s3uri
        source: load_bucket
        valueFrom: |
          ${
          return self + '/' + inputs.uuid + '/';
          }
      - id: uuid
        source: uuid
        valueFrom: null
    out:
      - id: output

  - id: load_bai
    run: ../../tools/aws_s3_put.cwl
    in:
      - id: aws_config
        source: aws_config
      - id: aws_shared_credentials
        source: aws_shared_credentials
      - id: endpoint_json
        source: endpoint_json
      - id: input
        source: dnaseq_workflow/picard_markduplicates_output_bam
        valueFrom: $(self.secondaryFiles[0])
      - id: s3cfg_section
        source: load_s3cfg_section
      - id: s3uri
        source: load_bucket
        valueFrom: |
          ${
          return self + '/' + inputs.uuid + '/';
          }
      - id: uuid
        source: uuid
        valueFrom: null
    out:
      - id: output

  - id: load_sqlite
    run: ../../tools/aws_s3_put.cwl
    in:
      - id: aws_config
        source: aws_config
      - id: aws_shared_credentials
        source: aws_shared_credentials
      - id: endpoint_json
        source: endpoint_json
      - id: input
        source: dnaseq_workflow/merge_all_sqlite_destination_sqlite
      - id: s3cfg_section
        source: load_s3cfg_section
      - id: s3uri
        source: load_bucket
        valueFrom: |
          ${
          return self + '/' + inputs.uuid + '/';
          }
      - id: uuid
        source: uuid
        valueFrom: null
    out:
      - id: output

  - id: generate_load_token
    run: ../../tools/generate_load_token.cwl
    in:
      - id: load1
        source: load_bam/output
      - id: load2
        source: load_bai/output
      - id: load3
        source: load_sqlite/output
    out:
      - id: token
