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
  - id: bam_normal_signpost_id
    type: string
  - id: bam_tumor_signpost_id
    type: string
  - id: endpoint_json
    type: File
  - id: known_indel_index_signpost_id
    type: string
  - id: known_indel_signpost_id
    type: string
  - id: known_snp_index_signpost_id
    type: string
  - id: known_snp_signpost_id
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
  - id: start_token
    type: File

outputs:
  - id: bam_normal_uuid
    type: string
    outputSource: emit_bam_normal_uuid/output
  - id: bam_tumor_uuid
    type: string
    outputSource: emit_bam_tumor_uuid/output
  - id: s3_bam_normal_url
    type: File
    outputSource: generate_s3_normal_path/output
  - id: s3_bam_tumor_url
    type: File
    outputSource: generate_s3_tumor_path/output
  - id: end_token
    type: File
    outputSource: generate_token/token

steps:
  - id: extract_bam_normal_signpost
    run: ../../tools/get_signpost_json.cwl
    in:
      - id: signpost_id
        source: bam_normal_signpost_id
      - id: base_url
        source: signpost_base_url
    out:
      - id: output

  - id: extract_bam_normal
    run: ../../tools/aws_s3_get_signpost.cwl
    in:
      - id: aws_config
        source: aws_config
      - id: aws_shared_credentials
        source: aws_shared_credentials
      - id: signpost_json
        source: extract_bam_normal_signpost/output
      - id: endpoint_json
        source: endpoint_json
    out:
      - id: output

  - id: get_bam_normal_uuid
    run: ../../tools/get_uuid.cwl
    in:
      []
    out:
      - id: uuid

  - id: emit_bam_normal_uuid
    run: ../../tools/emit_file_string.cwl
    in:
      - id: input
        source: get_bam_normal_uuid/uuid
    out:
      - id: output

  - id: extract_bai_normal
    run: ../../tools/aws_s3_get_bai_signpost.cwl
    in:
      - id: aws_config
        source: aws_config
      - id: aws_shared_credentials
        source: aws_shared_credentials
      - id: signpost_json
        source: extract_bam_normal_signpost/output
      - id: endpoint_json
        source: endpoint_json
    out:
      - id: output

  - id: extract_bam_tumor_signpost
    run: ../../tools/get_signpost_json.cwl
    in:
      - id: signpost_id
        source: bam_tumor_signpost_id
      - id: base_url
        source: signpost_base_url
    out:
      - id: output

  - id: extract_bam_tumor
    run: ../../tools/aws_s3_get_signpost.cwl
    in:
      - id: aws_config
        source: aws_config
      - id: aws_shared_credentials
        source: aws_shared_credentials
      - id: signpost_json
        source: extract_bam_tumor_signpost/output
      - id: endpoint_json
        source: endpoint_json
    out:
      - id: output


  - id: get_bam_tumor_uuid
    run: ../../tools/get_uuid.cwl
    in:
      []
    out:
      - id: uuid

  - id: emit_bam_tumor_uuid
    run: ../../tools/emit_file_string.cwl
    in:
      - id: input
        source: get_bam_tumor_uuid/uuid
    out:
      - id: output

  - id: extract_bai_tumor
    run: ../../tools/aws_s3_get_bai_signpost.cwl
    in:
      - id: aws_config
        source: aws_config
      - id: aws_shared_credentials
        source: aws_shared_credentials
      - id: signpost_json
        source: extract_bam_tumor_signpost/output
      - id: endpoint_json
        source: endpoint_json
    out:
      - id: output

  - id: extract_known_indel_signpost
    run: ../../tools/get_signpost_json.cwl
    in:
      - id: signpost_id
        source: known_indel_signpost_id
      - id: base_url
        source: signpost_base_url
    out:
      - id: output

  - id: extract_known_indel
    run: ../../tools/aws_s3_get_signpost.cwl
    in:
      - id: aws_config
        source: aws_config
      - id: aws_shared_credentials
        source: aws_shared_credentials
      - id: signpost_json
        source: extract_known_indel_signpost/output
      - id: endpoint_json
        source: endpoint_json
    out:
      - id: output

  - id: extract_known_indel_index_signpost
    run: ../../tools/get_signpost_json.cwl
    in:
      - id: signpost_id
        source: known_indel_index_signpost_id
      - id: base_url
        source: signpost_base_url
    out:
      - id: output

  - id: extract_known_indel_index
    run: ../../tools/aws_s3_get_signpost.cwl
    in:
      - id: aws_config
        source: aws_config
      - id: aws_shared_credentials
        source: aws_shared_credentials
      - id: signpost_json
        source: extract_known_indel_index_signpost/output
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

  - id: root_known_indel
    run: ../../tools/root_vcf_coclean.cwl
    in:
      - id: vcf
        source: extract_known_indel/output
      - id: vcf_index
        source: extract_known_indel_index/output
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

  - id: root_normal_bam
    run: ../../tools/root_bam_coclean.cwl
    in:
      - id: bam
        source: extract_bam_normal/output
      - id: bam_index
        source: extract_bai_normal/output
    out:
      - id: output

  - id: root_tumor_bam
    run: ../../tools/root_bam_coclean.cwl
    in:
      - id: bam
        source: extract_bam_tumor/output
      - id: bam_index
        source: extract_bai_tumor/output
    out:
      - id: output

  - id: transform
    run: transform.cwl
    in:
      - id: input_file
        source: [root_normal_bam/output, root_tumor_bam/output]
      - id: known_indel
        source: root_known_indel/output
      - id: known_snp
        source: root_known_snp/output
      - id: reference_sequence
        source: root_fasta/output
      - id: num_threads
        source: num_threads
      - id: uuid
        source: run_uuid
    out:
      - id: gatk_printreads_output_bam

  - id: get_transform_normal_bam_bai
    run: ../../tools/get_file_from_array.cwl
    in:
      - id: filearray
        source: transform/gatk_printreads_output_bam
      - id: filename
        source: extract_bam_normal/output
        valueFrom: $(self.basename)
    out:
      - id: output

  - id: get_transform_tumor_bam_bai
    run: ../../tools/get_file_from_array.cwl
    in:
      - id: filearray
        source: transform/gatk_printreads_output_bam
      - id: filename
        source: extract_bam_tumor/output
        valueFrom: $(self.basename)
    out:
      - id: output

  - id: load_bam_normal
    run: ../../tools/aws_s3_put.cwl
    in:
      - id: aws_config
        source: aws_config
      - id: aws_shared_credentials
        source: aws_shared_credentials
      - id: endpoint_json
        source: endpoint_json
      - id: input
        source: get_transform_normal_bam_bai/output
      - id: s3cfg_section
        source: load_s3cfg_section
      - id: s3uri
        source: load_bucket
        valueFrom: $(self + "/" + inputs.bam_uuid.contents + "/")
      - id: bam_uuid
        source: emit_bam_normal_uuid/output
        valueFrom: null
    out:
      - id: output

  - id: load_bai_normal
    run: ../../tools/aws_s3_put.cwl
    in:
      - id: aws_config
        source: aws_config
      - id: aws_shared_credentials
        source: aws_shared_credentials
      - id: endpoint_json
        source: endpoint_json
      - id: input
        source: get_transform_normal_bam_bai/output
        valueFrom: $(self.secondaryFiles[0])
      - id: s3cfg_section
        source: load_s3cfg_section
      - id: s3uri
        source: load_bucket
        valueFrom: $(self + "/" + inputs.bam_uuid.contents + "/")
      - id: bam_uuid
        source: emit_bam_normal_uuid/output
        valueFrom: null
    out:
      - id: output

  - id: load_bam_tumor
    run: ../../tools/aws_s3_put.cwl
    in:
      - id: aws_config
        source: aws_config
      - id: aws_shared_credentials
        source: aws_shared_credentials
      - id: endpoint_json
        source: endpoint_json
      - id: input
        source: get_transform_tumor_bam_bai/output
      - id: s3cfg_section
        source: load_s3cfg_section
      - id: s3uri
        source: load_bucket
        valueFrom: $(self + "/" + inputs.bam_uuid.contents + "/")
      - id: bam_uuid
        source: emit_bam_tumor_uuid/output
        valueFrom: null
    out:
      - id: output

  - id: load_bai_tumor
    run: ../../tools/aws_s3_put.cwl
    in:
      - id: aws_config
        source: aws_config
      - id: aws_shared_credentials
        source: aws_shared_credentials
      - id: endpoint_json
        source: endpoint_json
      - id: input
        source: get_transform_tumor_bam_bai/output
        valueFrom: $(self.secondaryFiles[0])
      - id: s3cfg_section
        source: load_s3cfg_section
      - id: s3uri
        source: load_bucket
        valueFrom: $(self + "/" + inputs.bam_uuid.contents + "/")
      - id: bam_uuid
        source: emit_bam_tumor_uuid/output
        valueFrom: null
    out:
      - id: output

  - id: generate_token
    run: ../../tools/generate_load_token.cwl
    in:
      - id: load1
        source: load_bai_normal/output
      - id: load2
        source: load_bai_tumor/output
      - id: load3
        source: load_bam_normal/output
      - id: load4
        source: load_bam_tumor/output
    out:
      - id: token

  - id: generate_s3_normal_path
    run: ../../tools/generate_s3load_path.cwl
    in:
      - id: load_bucket
        source: load_bucket
      - id: filename
        source: get_transform_normal_bam_bai/output
        valueFrom: $(self.basename)
      - id: uuid
        source: emit_bam_normal_uuid/output
    out:
      - id: output

  - id: generate_s3_tumor_path
    run: ../../tools/generate_s3load_path.cwl
    in:
      - id: load_bucket
        source: load_bucket
      - id: filename
        source: get_transform_tumor_bam_bai/output
        valueFrom: $(self.basename)
      - id: uuid
        source: emit_bam_tumor_uuid/output
    out:
      - id: output
