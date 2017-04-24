#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: MultipleInputFeatureRequirement
  - class: StepInputExpressionRequirement
  - class: SubworkflowFeatureRequirement

inputs:
  - id: aws_config
    type: File
  - id: aws_shared_credentials
    type: File
  - id: bam_signpost_id
    type: string
  - id: endpoint_json
    type: File
  - id: known_snp_index_signpost_id
    type: string
  - id: known_snp_signpost_id
    type: string
  - id: job_creation_uuid
    type: string
  - id: load_bucket
    type: string
  - id: load_s3cfg_section
    type: string
  - id: num_threads
    type: int
  - id: reference_dict_signpost_id
    type: string
  - id: reference_fa_signpost_id
    type: string
  - id: reference_fai_signpost_id
    type: string
  - id: run_uuid
    type: string
  - id: signpost_base_url
    type: string

outputs:
  - id: merge_sqlite_destination_sqlite
    type: File
    outputSource: merge_sqlite/destination_sqlite
  - id: generate_s3load_path_output
    type: string
    outputSource: generate_s3load_path/output

steps:
  - id: get_bam_uuid
    run: ../../tools/get_uuid.cwl
    in:
      []
    out:
      - id: uuid

  - id: emit_bam_uuid
    run: ../../tools/emit_file_string.cwl
    in:
      - id: input
        source: get_bam_uuid/uuid
    out:
      - id: output

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

  - id: extract_known_snp_signpost
    run: ../../tools/get_signpost_json.cwl
    in:
      - id: signpost_id
        source: known_snp_signpost_id
      - id: base_url
        source: signpost_base_url
    out:
      - id: output

  - id: extract_known_snp
    run: ../../tools/aws_s3_get_signpost.cwl
    in:
      - id: aws_config
        source: aws_config
      - id: aws_shared_credentials
        source: aws_shared_credentials
      - id: signpost_json
        source: extract_known_snp_signpost/output
      - id: endpoint_json
        source: endpoint_json
    out:
      - id: output

  - id: extract_known_snp_index_signpost
    run: ../../tools/get_signpost_json.cwl
    in:
      - id: signpost_id
        source: known_snp_index_signpost_id
      - id: base_url
        source: signpost_base_url
    out:
      - id: output

  - id: extract_known_snp_index
    run: ../../tools/aws_s3_get_signpost.cwl
    in:
      - id: aws_config
        source: aws_config
      - id: aws_shared_credentials
        source: aws_shared_credentials
      - id: signpost_json
        source: extract_known_snp_index_signpost/output
      - id: endpoint_json
        source: endpoint_json
    out:
      - id: output

  - id: extract_ref_dict_signpost
    run: ../../tools/get_signpost_json.cwl
    in:
      - id: signpost_id
        source: reference_dict_signpost_id
      - id: base_url
        source: signpost_base_url
    out:
      - id: output

  - id: extract_ref_dict
    run: ../../tools/aws_s3_get_signpost.cwl
    in:
      - id: aws_config
        source: aws_config
      - id: aws_shared_credentials
        source: aws_shared_credentials
      - id: signpost_json
        source: extract_ref_dict_signpost/output
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

  - id: root_fasta
    run: ../../tools/root_fasta_coclean.cwl
    in:
      - id: fasta
        source: extract_ref_fa/output
      - id: fasta_dict
        source: extract_ref_dict/output
      - id: fasta_index
        source: extract_ref_fai/output
    out:
      - id: output

  - id: root_known_snp
    run: ../../tools/root_vcf_coclean.cwl
    in:
      - id: vcf
        source: extract_known_snp/output
      - id: vcf_index
        source: extract_known_snp_index/output
    out:
      - id: output

  - id: transform
    run: transform.cwl
    in:
      - id: input_file
        source: extract_bam/output
      - id: known_snp
        source: root_known_snp/output
      - id: reference_sequence
        source: root_fasta/output
      - id: num_threads
        source: num_threads
      - id: run_uuid
        source: run_uuid
    out:
      - id: gatk_printreads_output_bam
      - id: integrity_sqlite

  - id: job_creation_uuid_sqlite
    run: ../../tools/table_string_sqlite_cell.cwl
    in:
      - id: table_name
        valueFrom: "job_creation_uuid"
      - id: cell_value
        source: job_creation_uuid
    out:
      - id: sqlite

  - id: merge_sqlite
    run: ../../tools/merge_sqlite.cwl
    in:
      - id: source_sqlite
        source: [
          transform/integrity_sqlite,
          job_creation_uuid_sqlite/sqlite
        ]
      - id: uuid
        source: run_uuid
    out:
      - id: destination_sqlite
      - id: log

  - id: generate_s3load_path
    run: ../../tools/generate_s3load_path.cwl
    in:
      - id: load_bucket
        source: load_bucket
      - id: filename
        source: transform/gatk_printreads_output_bam
        valueFrom: $(self.basename)
      - id: uuid
        source: emit_bam_uuid/output
    out:
      - id: output
